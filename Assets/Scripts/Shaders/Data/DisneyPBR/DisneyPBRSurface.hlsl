#ifndef DISNEYPBRSURFACE_INCLUDED
#define DISNEYPBRSURFACE_INCLUDED


struct DisneyPBRSurface 
{
	float4 BaseColor;
	float Roughness;
	float Metallic;
	
	float Specular;
	float SpecularTint;

	float Anisotropic;
	float ClearCoat;
	float ClearcoatGloss;
	float Sheen;
	
};

DisneyPBRSurface CreateSurface(float4 basecolor, float roughness, float metallic,
	float spec, float spectint, float ani, float clearcoat, float clearcoatgloss,
	float sheen) 
{
	DisneyPBRSurface surface;

	surface.BaseColor = basecolor;
	surface.Roughness = roughness;
	surface.Metallic = metallic;

	surface.
}




#endif