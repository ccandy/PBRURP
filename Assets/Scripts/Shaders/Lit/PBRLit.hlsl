#ifndef PBRLIT_INCLUDED
#define PBRLIT_INCLUDED

#include "Assets/Scripts/Shaders/Data/PBRSurface.hlsl"
#include "Assets/Scripts/Shaders/Data/PBRLight.hlsl"
#include "Assets/Scripts/Shaders/Data/PBRLighting.hlsl"

CBUFFER_START(UnityPerMaterial)
float4 _MainTex_ST;
float4 _Color;
float _Roughness;
float _Metallic;
CBUFFER_END

TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);

struct VertexInput
{
	float4 posOS : POSITION;
	float2 uv : TEXCOORD0;
	float3 normal:NORMAL;

	UNITY_VERTEX_INPUT_INSTANCE_ID

};

struct VertexOutput
{
	float2 uv : TEXCOORD0;
	float4 posCS : SV_POSITION;
	float3 posWS:TEXCOORD2;
	float3 normal:TEXCOORD1;
};


VertexOutput VertProgram(VertexInput input)
{
	VertexOutput output;

	output.posCS = TransformObjectToHClip(input.posOS.xyz);
	output.uv = TRANSFORM_TEX(input.uv, _MainTex);

	float3 normal = TransformObjectToWorldNormal(input.normal);
	normal = normalize(normal);
	output.normal = normal;

	float4x4 objectToWorld = GetObjectToWorldMatrix();
	float4 posWS = mul(objectToWorld, input.posOS);
	output.posWS = posWS.xyz;

	return output;
}

float4 FragProgram(VertexOutput input) : SV_Target
{
	float4 texCol = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);
	PBRSurface surface = CreateSurface(_Color, texCol, input.normal, _Metallic, _Roughness);
	PBRLight light = CreatePBRLight(_MainLightColor, _MainLightPosition);
	
	float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - input.posWS);
	float3 halfVector = normalize(viewDir + light.LightDir);
	
	float3 lightColor = CalcualteDirectionLight(surface, light, halfVector, viewDir);
	float4 finalCol = float4(lightColor, 1) * light.LightColor* PI;

	return finalCol;
}



#endif