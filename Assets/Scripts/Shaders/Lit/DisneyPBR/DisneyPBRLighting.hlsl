#ifndef DISNEYPBRLIGHTING_INCLUDED
#define DISNEYPBRLIGHTING_INCLUDED

//DirectionLight Diffuse

float pow5(float x) 
{
	return x * x * x * x * x;
}

float pow2(float x) 
{
	return x * x;
}

float Dot(float3 v1, float3 v2) 
{
	return saturate(dot(v1, v2));
}

float SchlickFresnel(float f90, float cosTheta) 
{
	float result = (1 + (f90 - 1) * pow5(1 - cosTheta));
	return result;
}

float3 CalcuateDirectionDiffuse(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	float3 normal = surface.Normal;
	float3 lightDir = light.LightDir;

	/*float LdotH = saturate(dot(lightDir, halfVector));
	float VdotN = saturate(dot(viewDir, normal));
	float LdotN = saturate(dot(lightDir, normal));
	*/

	float LdotH = Dot(lightDir, halfVector);
	float VdotN = Dot(viewDir, normal);
	float LdotN = Dot(lightDir, normal);

	float roughness = surface.Roughness;
	float F90 = 0.5 + 2 * roughness * LdotH * LdotH;

	float FL = SchlickFresnel(F90, LdotN);
	float FV = SchlickFresnel(F90, VdotN);

	float3 Fd = (surface.BaseColor.rgb / PI) * FL * FV;

	float Fss90 = LdotH * LdotH * roughness;
	float Fss = lerp(1.0, Fss90, FL) * lerp(1.0, Fss90, FV);
	float ss = 1.25 * (Fss * (1 / (LdotN + VdotN) - 0.5) + 0.5);

	float subsurface = surface.SubSurface;

	float3 diffuseColor =  lerp(Fd, ss, subsurface);


	float nl = max(saturate(dot(normal, lightDir)), 0.000001);
	return diffuseColor * nl;// *PI;
}

//spec

float SmithGGGXAniso(float NdotV, float VdotX, float VdotY, float ax, float ay)
{
	
	float ggx = 1 / (NdotV + pow2(pow2(VdotX * ax) + pow2(VdotY * ay) + pow2(NdotV));

	return ggx;
}

float GTR2Aniso

float3 CalcuateDirectionSpec(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	float aniostrpic = surface.Anisotropic;
	float roughness = surface.Roughness;

	float aspect = pow2(1 - aniostrpic * 0.09);
	float ax = max(0.001, pow2(roughness) / aspect);
	float ay = max(0.001, pow2(roughness) * aspect);

	return 1;
}




float3 CalcuateDirectionLightColor(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir) 
{
	float3 diffuse = CalcuateDirectionDiffuse(surface, light, halfVector, viewDir);
	float3 spec = CalcuateDirectionSpec(surface, light, halfVector, viewDir);

	float3 finalCol = diffuse;

	return finalCol;
}


#endif