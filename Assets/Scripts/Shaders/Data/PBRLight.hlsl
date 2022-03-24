#ifndef PBRLIGHT_INCLUDED
#define PBRLIGHT_INCLUDED

struct PBRLight
{
	float3 LightColor;
	float3 LightPosition;
	float3 LightDir;
};

PBRLight CreatePBRLight(float3 lightColor, float3 lightPos) 
{
	PBRLight light;

	light.LightColor = lightColor;
	light.LightPosition = lightPos;
	light.LightDir = normalize(lightPos);

	return light;
}

#endif