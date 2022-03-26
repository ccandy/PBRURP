#ifndef PBRLIGHT_INCLUDED
#define PBRLIGHT_INCLUDED

struct PBRLight
{
	float4 LightColor;
	float4 LightPosition;
	float3 LightDir;
};

PBRLight CreatePBRLight(float4 lightColor, float4 lightPos) 
{
	PBRLight light;

	light.LightColor = lightColor;
	light.LightPosition = lightPos;
	light.LightDir = normalize(lightPos.xyz);

	return light;
}

#endif