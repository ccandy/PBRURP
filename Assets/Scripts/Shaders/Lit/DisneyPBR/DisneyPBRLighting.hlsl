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


float SchlickFresnel(float f90, float cosTheta) 
{
	float result = (1 + (f90 - 1) * pow5(1 - cosTheta));
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

	float3 Fd = (surface.BaseColor.rgb / PI) * FL * FV;

	float Fss90 = LdotH * LdotH * roughness;
	float Fss = lerp(1.0, Fss90, FL) * lerp(1.0, Fss90, FV);


	float3 diffuseColor = Fd;


	float nl = max(saturate(dot(normal, lightDir)), 0.000001);
	return diffuseColor * nl * PI;
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