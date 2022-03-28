#ifndef DISNEYPBRSURFACE_INCLUDED
#define DISNEYPBRSURFACE_INCLUDED


struct DisneyPBRSurface 
{
	float4 BaseColor;
	float3 Normal;
	float3 Tangent;
	float3 BiNormal;

	float Roughness;
	float Metallic;
	float Luminance;

	float Specular;
	float SpecularTint;

	float Anisotropic;
	float ClearCoat;
	float ClearcoatGloss;
	float Sheen;
	float SubSurface;

	float3 ColorTint;
	
};

DisneyPBRSurface CreateSurface(float4 basecolor, float4 texcolor, float3 normal, float3 tangent, float roughness, float metallic,
	float spec, float spectint, float ani, float clearcoat, float clearcoatgloss,
	float sheen, float subsurface) 
{
	DisneyPBRSurface surface;

	surface.BaseColor = basecolor * texcolor;
	surface.Normal = normal;
	surface.Tangent = tangent;
	surface.BiNormal = cross(normal, tangent);

	surface.Roughness = roughness;
	surface.Metallic = metallic;

	surface.Specular = spec;
	surface.SpecularTint = spectint;

	surface.Anisotropic = ani;
	surface.ClearCoat = clearcoat;
	surface.ClearcoatGloss = clearcoatgloss;
	surface.Sheen = sheen;

	surface.SubSurface = subsurface;
	
	float luminance = 0.3 * basecolor.r + 0.6 * basecolor.g + 0.1 * basecolor.b;
	surface.Luminance = luminance;
	
	float cTint = luminance > 0 ? basecolor / luminance : float3(1, 1, 1);
	surface.ColorTint = cTint;



	return surface;
}




#endif