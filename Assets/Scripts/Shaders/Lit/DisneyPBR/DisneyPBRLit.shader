Shader "PBR/DisneyPBRLit"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Color", color) = (1,1,1,1)
        _Metallic("Metallic", Range(0,1)) = 1
        _Roughness("Roughness", Range(0,1)) = 0
        _Anisotropic("Anisotropic", Range(0,1)) = 1
        _Specular("Specular", Range(0,1)) = 1
        _SpecularTint("Specular Tint", Range(0,1)) = 1
        _ClearCoat("Clear Coat", Range(0,1)) = 1
        _ClearcoatGloss("Clear Coat Gloss", Range(0,1)) = 1
        _Sheen("Sheen", Range(0,1)) = 1
    }
        SubShader
        {
            Tags
            {
                "RenderType" = "Opaque"
                "RenderPipeline" = "UniversalRenderPipeline"
            }
            LOD 100
            HLSLINCLUDE
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

                #include "DisneyPBRLit.hlsl"
            ENDHLSL

            Pass
            {
                Tags
                {
                    "LightMode" = "UniversalForward"
                }
                HLSLPROGRAM
                #pragma vertex VertProgram
                #pragma fragment FragProgram
                ENDHLSL
            }
        }
}