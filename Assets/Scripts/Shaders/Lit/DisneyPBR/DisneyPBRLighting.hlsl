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

float GTR1(float NdotH, float a)
{
	if (a >= 1)
	{
		return 1 / PI;
	}

	float a2 = pow2(a);
	float t = 1 + (a2 - 1) * pow2(NdotH);
	return (a2 - 1) / (PI * log(a2) * t);
}

float GTR2(float NdotH, float a)
{
	float a2 = pow2(a);
	float t = 1 + (a2 - 1) * pow2(NdotH);
	return a2 / (PI * pow2(t));
}

float GTR2Aniso(float NdotH, float HdotX, float HdotY, float ax, float ay)
{
	float ggx = 1 / (PI * ax * ay * pow2(pow2(HdotX / ax) + pow2(HdotY / ay) + pow2(NdotH)));
	return ggx;
}

float SmithGGX(float NdotV, float alphaG)
{
	float a = pow2(alphaG);
	float b = pow2(NdotV);
	return 1 / (NdotV + sqrt(a + b - a * b));
}

float SmithGGGXAniso(float NdotV, float VdotX, float VdotY, float ax, float ay)
{
	float ggx = 1/ (NdotV + sqrt(pow2(VdotX * ax) + pow2(VdotY*ay) + pow2(NdotV)));
	return ggx;
}


float3 CalcuateFsheen(float FH, float sheen, float3 csheen)
{
	float3 Fsheen = FH * sheen * csheen;
	return Fsheen;
}

//float3 CalcuateDirectionDiffuse(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
float3 CalcuateDirectionDiffuse(MyBRDFData data)
{
	DisneyPBRSurface surface = data.surface;

	float3 normal = surface.Normal;
	float3 lightDir = data.light.LightDir;

	
	float LdotH = data.LdotH;
	float VdotN = data.VdotN;
	float LdotN = data.LdotN;

	float roughness = surface.Roughness;
	float F90 = 0.5 + 2 * roughness * LdotH * LdotH;

	float FL = DiffuseFresnel(F90, LdotN);
	float FV = DiffuseFresnel(F90, VdotN);

	float3 Fd = (surface.BaseColor.rgb / PI) * FL * FV;

	float Fss90 = LdotH * LdotH * roughness;
	float Fss = lerp(1.0, Fss90, FL) * lerp(1.0, Fss90, FV);
	float ss = 1.25 * (Fss * (1 / (LdotN + VdotN) - 0.5) + 0.5);

	float subsurface = surface.SubSurface;
	float metallic = surface.Metallic;

	float FH = SchlickFresnel(LdotH);
	float sheen = surface.Sheen;
	float3 csheen = surface.ColorSheen;

	float3 Fsheen = CalcuateFsheen(FH, sheen, csheen);
	float3 diffuseColor =  ((1/PI) * lerp(Fd, ss, subsurface) * surface.BaseColor.rgb + Fsheen) * (1 - metallic);

	float nl = max(saturate(dot(normal, lightDir)), 0.000001);
	return diffuseColor *nl *PI;
}
//spec
float3 CalcuateDirectionSpec(MyBRDFData data)
{
	DisneyPBRSurface surface = data.surface;
	PBRLight light = data.light;

	float aniostrpic = surface.Anisotropic;
	float roughness = surface.Roughness;
	float sheen = surface.Sheen;
	float clearcoatgloss = surface.ClearcoatGloss;
	float clearcoat = surface.ClearCoat;

	float3 normal = surface.Normal;
	float3 tangent = surface.Tangent;
	float3 binormal = surface.BiNormal;
	float3 lightdir = light.LightDir;
	float3 colorSpec = surface.ColorSpec0;
	float3 csheen = surface.ColorSheen;

	float NdotL = data.NdotL;
	float NdotH = data.NdotH;
	
	float HdotX = data.HdotX;
	float HdotY = data.HdotY;

	float LdotX = data.LdotX;
	float LdotY = data.LdotY;
	float LdotH = data.LdotH;

	float VdotX = data.VdotX;
	float VdotY = data.VdotY;

	float NdotV = data.NdotV;
	
	float aspect = sqrt(1 - aniostrpic * 0.09);
	float ax = max(0.001, pow2(roughness) / aspect);
	float ay = max(0.001, pow2(roughness) * aspect);

	float Ds = GTR2Aniso(NdotH, HdotX, HdotY, ax, ay);
	float FH = SchlickFresnel(LdotH);

	float3 Fs = lerp(colorSpec, float3(1, 1, 1), FH);

	float Gs = SmithGGGXAniso(NdotL, LdotX, LdotY, ax, ay);
	Gs *= SmithGGGXAniso(NdotV, VdotX, VdotY, ax, ay);

	float3 Fsheen = CalcuateFsheen(FH, sheen, csheen);

	float Dr = GTR1(NdotH, lerp(0.1, 0.001, clearcoatgloss));
	float Fr = lerp(0.04, 1.0, FH);
	float Gr = SmithGGX(NdotL, 0.25) * SmithGGX(NdotV, 0.25);

	float3 final = Gs * Fs * Ds + 0.25 * clearcoat * Gr * Fr * Dr;

	return final;
}




//float3 CalcuateDirectionLightColor(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir) 

float3 CalcuateDirectionLightColor(MyBRDFData data)
{
	DisneyPBRSurface surface = data.surface;
	PBRLight light = data.light;
	float3 halfVector = data.halfVector;
	float3 viewDir = data.viewDir;

	float3 diffuse = CalcuateDirectionDiffuse(data);
	float3 spec = CalcuateDirectionSpec(data);

	float3 finalCol = diffuse + spec;

	return finalCol;
}


#endif