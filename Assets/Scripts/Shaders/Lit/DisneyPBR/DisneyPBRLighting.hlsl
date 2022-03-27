#ifndef DISNEYPBRLIGHTING_INCLUDED
#define DISNEYPBRLIGHTING_INCLUDED

//DirectionLight Diffuse


float SchlickFresnel(float f90, float cosTheta) 
{
	float result = (1 + (f90 - 1) * pow((1 - cosTheta), 5));
	return result;
}

float3 CalcuateDirectionDiffuse(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	float3 normal = surface.Normal;
	float3 lightDir = light.LightDir;

	float LdotH = saturate(dot(lightDir,halfVector));
	float VdotN = saturate(dot(viewDir, normal));
	float LdotN = saturate(dot(lightDir, normal));


	float roughness = surface.Roughness;
	float F90 = 0.5 + 2 * roughness * LdotH * LdotH;

	float FL = SchlickFresnel(F90, LdotN);
	float FV = SchlickFresnel(F90, VdotN);

	float3 diffuseColor = (surface.BaseColor.rgb / PI) * FL * FV;

	return diffuseColor;
}

float3 CalcuateDirectionSpec(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	return 1;
}

float3 CalcuateDirectionLightColor(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir) 
{
	float3 diffuse = CalcuateDirectionDiffuse(surface, light, halfVector, viewDir);
	float3 spec = CalcuateDirectionSpec(surface, light, halfVector, viewDir);

	float3 finalCol = diffuse + spec;

	return finalCol;
}


#endif