#ifndef DEFAULTLIT_INCLUDED
#define DEFAULTLIT_INCLUDED

#include "Assets/Scripts/Shaders/Data/RegularSurface.hlsl"
#include "Assets/Scripts/Shaders/Data/RegularLight.hlsl"
#include "DefaultLighting.hlsl"


CBUFFER_START(UnityPerMaterial)
float4 _MainTex_ST;
float4 _Color;
float _Shinness;
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
	RegularSurface surface = CreateRegularSurface(_Color, texCol, input.normal, _Shinness);
	RegularLight light = CreateRegularLight(_MainLightColor.rgb, _MainLightPosition.xyz, _MainLightPosition.xyz);
	float3 viewDir = normalize(light.LightPos - input.posWS);

	float3 diffuse = CalculateDiffuseColor(surface, light);
	float3 spec = CalcualteSpec(surface, light, viewDir);
	float4 finalCol = surface.baseColor * float4(diffuse + spec, 1);
	return finalCol;
}

#endif