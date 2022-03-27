#ifndef DISNEYPBRLIGHTING_INCLUDED
#define DISNEYPBRLIGHTING_INCLUDED

//DirectionLight Diffuse

float3 CalcuateDirectionDiffuse(DisneyPBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	return 1;
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