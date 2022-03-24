#ifndef PBRSURFACE_INCLUDED
#define PBRSURFACE_INCLUDED

struct PBRSurface 
{
	float4 BaseColor;
	float Metallic;
	float Rougnness;
};


PBRSurface CreateSurface(float4 color, float texColor, float metallic, float roughness) 
{
	PBRSurface surface;

	surface.BaseColor = color * texColor;
	surface.metallic = Metallic;
	surface.Roughness = roughness;

	return surface;
}


#endif