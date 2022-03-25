#ifndef PBRSURFACE_INCLUDED
#define PBRSURFACE_INCLUDED

struct PBRSurface 
{
	float4 BaseColor;
	float Metallic;
	float Rougnness;
	float3 BaseF0;
	float3 NormalWS;
};


PBRSurface CreateSurface(float4 color, float4 texColor, float3 normal, float metallic, float roughness) 
{
	PBRSurface surface;

	surface.BaseColor = color * texColor;
	surface.Metallic = metallic;
	surface.Rougnness = roughness;

	float3 baseF0 = float3(0.04, 0.04, 0.04);
	float3 surfaceColor = surface.BaseColor.rgb;
	surface.BaseF0 = lerp(baseF0, surfaceColor, metallic);
	surface.NormalWS = normal;

	return surface;
}


#endif