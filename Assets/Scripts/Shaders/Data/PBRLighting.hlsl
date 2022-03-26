#ifndef PBRLIGHTING_INCLUDED
#define PBRLIGHTING_INCLUDED

//CalcualteDirectionLightColor

SAMPLER(sampler_unity_SpecCube0);
#define unity_ColorSpaceDielectricSpec half4(0.04, 0.04, 0.04, 1.0 - 0.04) 

float3 FresnelEquation(float3 baseF0, float3 halfVector, float3 viewDir)
{
	float vh = max(saturate(dot(viewDir, halfVector)), 0.000001);
	float3 F = baseF0 + (1 - baseF0) * pow(1.0 - vh, 5.0);

	return F;
}


float DistributionGGX(PBRSurface surface, float3 halfVector)
{
	float roughness = surface.Roughness;
	float roughness2 = roughness * roughness;

	float NdotH = dot(surface.NormalWS, halfVector);
	float NdotH2 = NdotH * NdotH;

	float temp = NdotH2 * (roughness2 - 1) + 1;
	float temp2 = temp * temp;
	temp2 *= PI;

	float result = roughness2 / temp2;

	return result;
}

float3 CalcualteDirectionLightDiffuseColor(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir) 
{
	
	float3 F = FresnelEquation(surface.BaseF0, halfVector, viewDir);
	float3 kd = (1 - F) * (1 - surface.Metallic);
	float3 baseColor = surface.BaseColor.rgb;
	float3 diffuseColor = baseColor / PI * kd;
	
	return diffuseColor;
}

float ShlickGGX(PBRSurface surface, float3 dir, float k) 
{
	float ndotd = saturate(dot(surface.NormalWS, dir));
	float result = ndotd / (ndotd * (1 - k) + k);

	return result;
}


float GeometrySmith(PBRSurface surface, PBRLight light, float3 viewDir) 
{
	float roughness = surface.Roughness;
	float k = (roughness + 1) * (roughness + 1) / 8;

	float G = ShlickGGX(surface, viewDir, k) * ShlickGGX(surface, light.LightDir, k);
	return G;
}



float3 CalcualteDirectionLightSpecColor(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	float3 F = FresnelEquation(surface.BaseF0, halfVector, viewDir);
	float D = DistributionGGX(surface, halfVector);
	float G = GeometrySmith(surface, light, viewDir);
	float NdotV = max(saturate(dot(surface.NormalWS, viewDir)), 0.000001);
	float NdotL = max(saturate(dot(surface.NormalWS, light.LightDir)), 0.000001);

	float3 FDG = F* G* D;
	FDG /= 4 * NdotV * NdotL;


	return FDG;
}
float3 CalcualteDirectionLight(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	float3 diffuseColor = CalcualteDirectionLightDiffuseColor(surface, light, halfVector, viewDir);
	float3 specColor = CalcualteDirectionLightSpecColor(surface, light, halfVector, viewDir);

	float nl = max(saturate(dot(surface.NormalWS, light.LightDir)), 0.000001);

	return (diffuseColor + specColor) * nl;
}

//CalcualteInDirectionLightColor

float3 FresnelSchlickRoughness(PBRSurface surface, float3 viewDir) 
{
	float3 normal = surface.NormalWS;
	float nv = dot(normal, viewDir);
	nv = max(nv, 0.0);

	float roughness = surface.Roughness;
	float3 F0 = surface.BaseF0;

	return F0 + (max(float3(1, 1, 1) * (1 - roughness), F0) - F0) * pow(1.0 - nv, 5.0);

}

float CubeMapMip(float roughness) 
{
	float mipRoughness = roughness * (1.7 - 0.7 * roughness);
	float mip = mipRoughness * UNITY_SPECCUBE_LOD_STEPS;

	return mip;
}


float3 CalculateInDirectionDiffuseColor(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir) 
{
	float3 normal = surface.NormalWS;
	float3 iblDiffuse = SampleSH(normal);
	
	float3 Flast = FresnelSchlickRoughness(surface, viewDir);
	float3 kLast = (1 - Flast) * (1 - surface.Metallic);
	float nl = max(saturate(dot(surface.NormalWS, light.LightDir)), 0.000001);
	float3 iblDiffuseResult = iblDiffuse * kLast * surface.BaseColor.rgb;
	return iblDiffuseResult;
}

float3 CalculateInDirectionSpecColor(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir)
{
	float roughness = surface.Roughness;
	float mip = CubeMapMip(roughness);
	float3 reflectVec = reflect(-viewDir, surface.NormalWS);
	
	half4 param = half4(reflectVec, mip);
	
	//float4 rgbm = texCUBElod(unity_SpecCube0, param);
	float4 rgbm = SAMPLE_TEXTURECUBE_LOD(unity_SpecCube0, sampler_unity_SpecCube0, reflectVec, mip);
	float3 iblSpec = DecodeHDREnvironment(rgbm, unity_SpecCube0_HDR);
	
	float surfaceReduction = 1.0 / (roughness * roughness + 1.0);
	float oneMinusReflectivity = unity_ColorSpaceDielectricSpec.a - unity_ColorSpaceDielectricSpec.a * surface.Metallic;

	float grazingTerm = saturate((1 - roughness) + (1 - oneMinusReflectivity));
	float nv = max(saturate(dot(surface.NormalWS, viewDir)), 0.000001);
	float t = pow((1 - nv), 5);
	float3 FresnelLerp = lerp(surface.BaseF0, grazingTerm, t);

	float3 iblSpecularResult = surfaceReduction * iblSpec * FresnelLerp;

	//return iblSpec;

	return iblSpecularResult;
}

float3 CalcualteInDirectionColor(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir) 
{
	float3 inDirectionDiffuse = CalculateInDirectionDiffuseColor(surface, light, halfVector, viewDir);
	float3 inDirectionSpec = CalculateInDirectionSpecColor(surface, light, halfVector, viewDir);
	float nl = max(saturate(dot(surface.NormalWS, light.LightDir)), 0.000001);
	float3 inDirectionResult = (inDirectionDiffuse + inDirectionSpec) * nl;
	return inDirectionSpec;

	return inDirectionResult;
}

float3 CalculateLightColor(PBRSurface surface, PBRLight light, float3 halfVector, float3 viewDir) 
{
	float3 directionLightColor = CalcualteDirectionLight(surface, light, halfVector, viewDir);
	float3 inDirectionLightColor = CalcualteInDirectionColor(surface, light, halfVector, viewDir);

	float3 lightColor = directionLightColor + inDirectionLightColor;

	//return inDirectionLightColor;

	return lightColor;
}

#endif