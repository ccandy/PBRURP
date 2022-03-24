#ifndef UNLIT_INCLUDED
#define UNLIT_INCLUDED


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
	UNITY_VERTEX_INPUT_INSTANCE_ID
	
};

struct VertexOutput
{
    float2 uv : TEXCOORD0;
	float4 posCS : SV_POSITION;
};


VertexOutput VertProgram(VertexInput input)
{
	VertexOutput output;

	output.posCS = TransformObjectToHClip(input.posOS.xyz);
	output.uv = TRANSFORM_TEX(input.uv, _MainTex);

    return output;
}

float4 FragProgram(VertexOutput input) : SV_Target
{

	float4 texCol = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);
	float4 finalCol = texCol * _Color;

	
	return finalCol;
}


#endif