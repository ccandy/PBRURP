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

DisneyPBRSurface CreateSurface(float4 basecolor, float4 texcolor, float roughness, float metallic,
	float spec, float spectint, float ani, float clearcoat, float clearcoatgloss,
	float sheen) 
{
	DisneyPBRSurface surface;

	surface.BaseColor = basecolor * texcolor;
	surface.Roughness = roughness;
	surface.Metallic = metallic;

	surface.Specular = spec;
	surface.SpecularTint = spectint;

	surface.Anisotropic = ani;
	surface.ClearCoat = clearcoat;
	surface.ClearcoatGloss = clearcoatgloss;
	surface.Sheen = sheen;

	return surface;
}




#endif