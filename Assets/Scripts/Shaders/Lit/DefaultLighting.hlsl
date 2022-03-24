#ifndef DEFAULTLIGHTING_INCLUDED
#define DEFAULTLIGHTING_INCLUDED

float CalculateDiffuse(float3 normalDir, float3 lightDir) 
{
	float diffuse = max(saturate(dot(normalDir, lightDir)), 0.00001);
	return diffuse;
}



#endif