#ifndef PBRLIGHTING_INCLUDED
#define PBRLIGHTING_INCLUDED

//#define PI 3.141592654f;


float3 FresnelEquation(float3 baseF0, float3 halfVector,float3 viewDir)
{
	float vh = max(saturate(dot(viewDir, halfVector)), 0.000001);
	float3 F = baseF0 + (1 - baseF0) * pow(1.0 - vh, 5.0);

	return F;
}


float DistributionGGX(PBRSurface surface, float3 halfVector) 
{
	float roughness = surface.Roughness;
	float roughness2 = roughness * roughness;

	float NdotH = dot(surface.NormalWS, halfVector);
	float NdotH2 = NdotH * NdotH;

	float temp = NdotH2 * (roughness2 - 1) + 1;
	float temp2 = temp * temp;
	temp2 *= PI;

	float result = roughness2 / temp2;

	return result;
}

// Calculate Direction Light


//CalcualteDirectionLightColor
float3 CalcualteDirectionLightDiffuseColor(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir) 
{
	
	float3 F = FresnelEquation(surface.BaseF0, halfVector, viewDir);
	float3 kd = (1 - F) * (1 - surface.Metallic);
	float3 baseColor = surface.BaseColor.rgb;
	float3 diffuseColor = baseColor / PI * kd;
	float3 nl = max(saturate(dot(surface.NormalWS, light.LightDir)), 0.000001);

	diffuseColor *= nl;


	return diffuseColor;
}

float ShlickGGX(PBRSurface surface, float3 dir, float k) 
{
	float ndotd = dot(surface.NormalWS, dir);
	float result = ndotd / (ndotd * (1 - k) + k);

	return result;
}


float GeometrySmith(PBRSurface surface, PBRLight light, float3 viewDir) 
{
	float roughness = surface.Roughness;
	float k = (roughness + 1) * (roughness + 1) / 8;

	float G = ShlickGGX(surface, viewDir, k) * ShlickGGX(surface, light.LightDir, k);
	return G;
}



float3 CalcualteDirectionLightSpecColor(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	float3 F = FresnelEquation(surface.BaseF0, halfVector, viewDir);
	float D = DistributionGGX(surface, halfVector);
	float G = GeometrySmith(surface, light, viewDir);

	return D;
}
float3 CalcualteDirectionLight(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	float3 diffuseColor = CalcualteDirectionLightDiffuseColor(surface, light, halfVector, viewDir);
	return diffuseColor;
}




#endif