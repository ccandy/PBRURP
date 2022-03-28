#ifndef DISNEYPBRLIT_INCLUDED
#define DISNEYPBRLIT_INCLUDED

#include "Assets/Scripts/Shaders/Util/MathFunction.hlsl"
#include "Assets/Scripts/Shaders/Data/DisneyPBR/DisneyPBRSurface.hlsl"
#include "Assets/Scripts/Shaders/Data/PBR/PBRLight.hlsl"
#include "Assets/Scripts/Shaders/Data/DisneyPBR/BRDFData.hlsl"
#include "DisneyPBRLighting.hlsl"

//Assets\Scripts\Shaders\Data\DisneyPBR
CBUFFER_START(UnityPerMaterial)
	float4 _MainTex_ST;
	float4 _Color;
	
	float _Roughness;
	float _Metallic;
	
	float _Anisotropic;
	float _Specular;
	float _SpecularTint;
	float _ClearCoat;
	float _ClearcoatGloss;
	float _Sheen;
	float _SheenTint;
	float _SubSurface;

CBUFFER_END

TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);


struct VertexInput
{
	float4 posOS : POSITION;
	float2 uv : TEXCOORD0;
	float3 normal:NORMAL;
	float4 tangent:TANGENT;

	UNITY_VERTEX_INPUT_INSTANCE_ID

};


struct VertexOutput
{
	float2 uv : TEXCOORD0;
	float4 posCS : SV_POSITION;
	float3 posWS:TEXCOORD2;
	float3 normal:TEXCOORD1;
	float3 tangent:TEXCOORD3;
};

VertexOutput VertProgram(VertexInput input)
{
	VertexOutput output;
	output.posCS = TransformObjectToHClip(input.posOS.xyz);
	output.uv = TRANSFORM_TEX(input.uv, _MainTex);
	
	//nomral
	float3 normal = TransformObjectToWorldNormal(input.normal);
	normal = normalize(normal);
	output.normal = normal;
	
	//tangent
	float3 tangent = TransformObjectToWorldDir(input.tangent.xyz);
	output.tangent = tangent;


	float4x4 objectToWorld = GetObjectToWorldMatrix();
	float4 posWS = mul(objectToWorld, input.posOS);
	output.posWS = posWS.xyz;

	return output;
}

float4 FragProgram(VertexOutput input) : SV_Target
{
	float4 texCol = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);
	float3 normal = input.normal;
	float3 tangent = input.tangent;
	DisneyPBRSurface surface = CreateSurface(_Color, texCol, normal,tangent, _Roughness, _Metallic,
		_Anisotropic, _Specular, _SpecularTint,
		_ClearCoat, _ClearcoatGloss, _Sheen, _SheenTint, _SubSurface);
	PBRLight light = CreatePBRLight(_MainLightColor, _MainLightPosition);

	float3 lightDir = light.LightDir;
	float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - input.posWS);
	
	float3 halfVector = normalize(viewDir + lightDir);

	float3 lightCol = CalcuateDirectionLightColor(surface, light, halfVector, viewDir);
	
	float3 finalCol = lightCol * light.LightColor.rgb;
	

	return float4(finalCol, 1);
}

#endif