#ifndef DEFAULTLIGHTING_INCLUDED
#define DEFAULTLIGHTING_INCLUDED

float CalculateDiffuse(RegularSurface surface, RegularLight light) 
{
	float3 normalDir = surface.Normal;
	float3 lightDir = light.LightDir;
	float diffuse = max(saturate(dot(normalDir, lightDir)), 0.00001);
	return diffuse;
}

float3 CalculateDiffuseColor(RegularSurface surface, RegularLight light) 
{
	float diffuse = CalculateDiffuse(surface, light);
	float3 diffuseColor = light.LightColor * diffuse;

	return diffuseColor;
}



float CalculatePhong(RegularSurface surface, RegularLight light, float3 viewDir) 
{
	float3 normalDir = surface.Normal;
	float3 lightDir = light.LightDir;

	float3 refDir = reflect(-lightDir, normalDir);
	float spec = max(saturate(dot(refDir, viewDir)), 0.00001);

	return spec;

}

float3 CalcualteSpec(RegularSurface surface, RegularLight light, float3 viewDir) 
{
	float spec = CalculatePhong(surface, light, viewDir);
	float shinness = surface.Shinness;

	float pShinness = pow(spec, shinness);

	float3 specColor = light.LightColor * pShinness * surface.SpecStrength;

	return specColor;
}

#endif