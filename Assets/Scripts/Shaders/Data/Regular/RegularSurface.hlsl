#ifndef REGULARSURFACE_INCLUDED
#define REGULARSURFACE_INCLUDED

struct RegularSurface 
{
	float4 BaseColor;
	float3 Normal;
	float Shinness;
	float SpecStrength;
};

RegularSurface CreateRegularSurface(float4 color, float4 texColor, float3 normal, float shinness, float specstrength)
{
	RegularSurface surface;
	
	surface.BaseColor = color * texColor;
	surface.Normal = normal;
	surface.Shinness = shinness;
	surface.SpecStrength = specstrength;

	return surface;
}


#endif