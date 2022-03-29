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
	float3 ColorSpec0;
	float3 ColorSheen;
	
};

DisneyPBRSurface CreateSurface(float4 basecolor, float4 texcolor, float3 normal, float3 tangent, float3 binormal, float roughness, float metallic,
	float spec, float spectint, float ani, float clearcoat, float clearcoatgloss,
	float sheen, float sheenTint, float subsurface) 
{
	DisneyPBRSurface surface;

	surface.BaseColor = basecolor * texcolor;
	surface.Normal = normal;
	surface.Tangent = tangent;
	surface.BiNormal = binormal;

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
	
	float3 cTint = luminance > 0 ? basecolor.rgb / luminance : float3(1, 1, 1);
	surface.ColorTint = cTint;
	
	float3 temp1 = spec * 0.08 * lerp(float3(1, 1, 1), cTint, spectint);
	float3 cSpec0 = lerp(temp1, cTint, spectint);
	surface.ColorSpec0 = cSpec0;

	float3 cSheen = lerp(float3(1, 1, 1), cTint, sheenTint);
	surface.ColorSheen = cSheen;

	return surface;
}




#endif