Shader "PBR/DisneyPBRLit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
