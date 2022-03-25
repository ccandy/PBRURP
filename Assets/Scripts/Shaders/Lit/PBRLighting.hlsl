#ifndef PBRLIGHTING_INCLUDED
#define PBRLIGHTING_INCLUDED

#define PI 3.141592654f;


float3 FresnelEquation(float3 baseF0, float3 halfVector,float3 viewDir)
{
	float vh = max(saturate(dot(viewDir, halfVector)), 0.000001);
	float3 F = F0 + (1 - F0) * pow(1.0 - vh, 5.0);

	return F;
}

// Calculate Direction Light
float3 CalcualteDirectionLight(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir) 
{
	float3 diffuseColor = CalcualteDirectionLightDiffuseColor(surface, light, halfVector, viewDir);
	return diffuseColor;
}

//CalcualteDirectionLightColor
float3 CalcualteDirectionLightDiffuseColor(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir) 
{
	
	float3 F = FresnelEquation(surface.BaseF0, halfVector, viewDir);
	float3 kd = (1 - F) * (1 - surface.Metallic);

	float3 diffuseColor = (surface.SurfaceColor / PI) * kd;

	return diffuseColor * light.LightColor;
}

float3 CalcualteDirectionLightSpecColor(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	float F = FresnelEquation(surface.BaseF0, halfVector, viewDir);

	return 1;
}





#endif