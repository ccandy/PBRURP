#ifndef BRDFDATA_INCLUDED
#define BRDFDATA_INCLUDED

struct MyBRDFData 
{
	DisneyPBRSurface surface;
	PBRLight light;

	float3 halfVector;

	float NdotL;
	float NdotH; 

	float HdotX; 
	float HdotY;

	float LdotX; 
	float LdotY;
	float LdotH;

	float VdotX; 
	float VdotY;

	float NdotV;
};


MyBRDFData CreateData(DisneyPBRSurface surface, PBRLight light, float3 viewDir)
{

	MyBRDFData data;
	data.surface = surface;
	data.light = light;

	float3 lightDir = light.LightDir;
	float3 halfVector = normalize(viewDir + lightDir);
	float3 normal = surface.Normal;
	float3 tangent = surface.Tangent;
	float3 binormal = surface.BiNormal;

	data.NdotL = Dot(normal, lightDir);
	data.NdotH = Dot(normal, halfVector);
	
	data.HdotX = Dot(halfVector, tangent);
	data.HdotY = Dot(halfVector, binormal);

	data.LdotX = Dot(lightDir, tangent);
	data.LdotY = Dot(lightDir, binormal);
	data.LdotH = Dot(lightDir, halfVector);

	data.VdotX = Dot(viewDir, tangent);
	data.VdotY = Dot(viewDir, binormal);

	data.NdotV = Dot(normal, viewDir);

	return data;

}










#endif