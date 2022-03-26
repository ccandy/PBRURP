#ifndef REGULARLIGHT_INCLUDED
#define REGULARLIGHT_INCLUDED

struct RegularLight
{
	float3 LightColor;
	float3 LightDir;
	float3 LightPos;
};

RegularLight CreateRegularLight(float3 lightColor, float3 lightDir, float3 lightPos)
{
	RegularLight light;

	light.LightColor = lightColor;
	light.LightDir = normalize(lightDir);
	light.LightPos = lightPos;

	return light;
}

#endif