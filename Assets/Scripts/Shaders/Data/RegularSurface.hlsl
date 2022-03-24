#ifndef REGULARSURFACE_INCLUDED
#define REGULARSURFACE_INCLUDED

struct RegularSurface 
{
	
	float4 baseColor;
	float3 normal;
};

RegularSurface CreateRegularSurface(float4 color, float4 texColor, float3 normal)
{
	RegularSurface surface;
	
	surface.baseColor = color * texColor;
	surface.normal = normal;

	return surface;
}


#endif