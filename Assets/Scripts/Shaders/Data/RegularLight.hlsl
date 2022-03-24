#ifndef REGULARLIGHT_INCLUDED
#define REGULARLIGHT_INCLUDED

struct RegularLight
{
	float3 LightColor;
	float3 LightDir;
};

RegularLight CreateRegularLight(float3 lightColor, float3 lightDir)
{
	RegularLight light;

	light.LightColor = lightColor;
	light.LightDir = normalize(lightDir);

	return light;
}

#endif