#ifndef MATHFUNCTION_INCLUDED
#define MATHFUNCTION_INCLUDED

float pow5(float x)
{
	return x * x * x * x * x;
}

float pow2(float x)
{
	return x * x;
}

float Dot(float3 v1, float3 v2)
{
	return saturate(dot(v1, v2));
}


#endif