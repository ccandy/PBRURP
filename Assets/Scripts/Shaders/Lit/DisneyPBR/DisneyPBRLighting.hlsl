#ifndef DISNEYPBRLIGHTING_INCLUDED
#define DISNEYPBRLIGHTING_INCLUDED

//DirectionLight Diffuse


float DiffuseFresnel(float f90, float cosTheta) 
{
	float result = (1 + (f90 - 1) * pow5(1 - cosTheta));
	return result;
}

float SchlickFresnel(float u) 
{
	float m = clamp(1 - u, 0, 1);
	return pow5(m);
}

float3 CalcuateDirectionDiffuse(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	float3 normal = surface.Normal;
	float3 lightDir = light.LightDir;

	
	float LdotH = Dot(lightDir, halfVector);
	float VdotN = Dot(viewDir, normal);
	float LdotN = Dot(lightDir, normal);

	float roughness = surface.Roughness;
	float F90 = 0.5 + 2 * roughness * LdotH * LdotH;

	float FL = DiffuseFresnel(F90, LdotN);
	float FV = DiffuseFresnel(F90, VdotN);

	float3 Fd = (surface.BaseColor.rgb / PI) * FL * FV;

	float Fss90 = LdotH * LdotH * roughness;
	float Fss = lerp(1.0, Fss90, FL) * lerp(1.0, Fss90, FV);
	float ss = 1.25 * (Fss * (1 / (LdotN + VdotN) - 0.5) + 0.5);

	float subsurface = surface.SubSurface;

	float3 diffuseColor =  lerp(Fd, ss, subsurface);


	float nl = max(saturate(dot(normal, lightDir)), 0.000001);
	return diffuseColor * nl;// *PI;
}

float SmithGGGXAniso(float NdotV, float VdotX, float VdotY, float ax, float ay)
{
	
	float ggx = 1 / (NdotV + sqrt(pow2(VdotX * ax) + pow2(VdotY * ay) + pow2(NdotV)));

	return ggx;
}

float GTR2Aniso(float NdotH, float HdotX, float HdotY, float ax, float ay) 
{
	float ggx = 1 / (PI * ax * ay * pow2(pow2(HdotX / ax) + pow2(HdotY / ay) + NdotH * NdotH));
	return ggx;
}

float3 CalcuateFsheen(float FH, float sheen, float3 csheen) 
{
	float3 Fsheen = FH * sheen * csheen;
	return Fsheen;
}

float GTR1(float NdotH, float a)
{
	if (a >= 1) 
	{
		return 1 / PI;
	}

	float a2 = pow2(a);
	float t = 1 + (a2 - 1) * pow2(NdotH);
	return (a2 - 1) / (PI * log2(a2) * t);
}

float GTR2(float NdotH, float a)
{
	float a2 = pow2(a);
	float t = 1 + (a2 - 1) * pow2(NdotH);
	return a2 / (PI * log2(a2) * t);
}

float SmithGGX(float NdotV, float alphaG) 
{
	float a = pow2(alphaG);
	float b = pow2(NdotV);
	return 1 / (NdotV + sqrt(a + b - a * b));
}

float3 CalcuateDirectionSpec(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	float aniostrpic = surface.Anisotropic;
	float roughness = surface.Roughness;
	float sheen = surface.Sheen;
	float clearcoatgloss = surface.ClearcoatGloss;

	float3 normal = surface.Normal;
	float3 tangent = surface.Tangent;
	float3 binormal = surface.BiNormal;
	float3 lightdir = light.LightDir;
	float3 colorSpec = surface.ColorSpec0;
	float3 csheen = surface.ColorSheen;

	float aspect = sqrt(1 - aniostrpic * 0.09);
	float ax = max(0.001, pow2(roughness) / aspect);
	float ay = max(0.001, pow2(roughness) * aspect);

	float NdotL = Dot(normal, lightdir);
	float NdotH = Dot(normal, halfVector);
	
	float HdotX = Dot(halfVector, tangent);
	float HdotY = Dot(halfVector, binormal);

	float LdotX = Dot(lightdir, tangent);
	float LdotY = Dot(lightdir, binormal);
	float LdotH = Dot(lightdir, halfVector);

	float VdotX = Dot(viewDir, tangent);
	float VdotY = Dot(viewDir, binormal);

	float NdotV = Dot(normal, viewDir);

	float Ds = GTR2Aniso(NdotH, HdotX, HdotY, ax, ay);
	float FH = SchlickFresnel(LdotH);

	float3 Fs = lerp(colorSpec, float3(1, 1, 1), FH);
	float Gs = SmithGGGXAniso(NdotL, LdotX, LdotY, ax, ay);
	Gs *= SmithGGGXAniso(NdotV, VdotX, VdotY, ax, ay);

	float3 Fsheen = CalcuateFsheen(FH, sheen, csheen);

	float Dr = GTR1(NdotH, lerp(0.1, 0.001, clearcoatgloss));
	float Fr = lerp(0.04, 1.0, FH);
	float Gr = SmithGGX(NdotL, 0.25) * SmithGGX(NdotV, 0.25);

	float3 final = Gs * Fs * Ds + 0.25 * clearcoatgloss * Gr * Fr * Dr;

	return final;
}




//float3 CalcuateDirectionLightColor(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir) 

float3 CalcuateDirectionLightColor(MyBRDFData data)
{
	DisneyPBRSurface surface = data.surface;
	PBRLight light = data.light;
	float3 halfVector = data.halfVector;
	float3 viewDir = data.viewDir;

	float3 diffuse = CalcuateDirectionDiffuse(surface, light, halfVector, viewDir);
	float3 spec = CalcuateDirectionSpec(surface, light, halfVector, viewDir);

	float3 finalCol = spec;

	return finalCol;
}


#endif