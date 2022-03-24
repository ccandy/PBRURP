#ifndef DEFAULTLIT_INCLUDED
#define DEFAULTLIT_INCLUDED


CBUFFER_START(UnityPerMaterial)
float4 _MainTex_ST;
float4 _Color;
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

	return output;
}

float4 FragProgram(VertexOutput input) : SV_Target
{
	float4 texCol = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);
	RegularSurface surface = CreateRegularSurface(_Color, texCol, input.normal);
	RegularLight light = CreateRegularLight(_MainLightColor.rgb, _MainLightPosition.xyz);
	
	float diffuse = CalculateDiffuse(surface.normal, light.LightDir);
	float4 finalCol = surface.baseColor * diffuse;
	return finalCol;
}

#endif