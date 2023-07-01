vec3 a = vec3(3, 4, 5),b = vec3(4, 3, 5),c = vec3(-5, -12, -13);

float dotProduct(vec3 a, vec3 b)
{
	return a.x*b.x+a.y*b.y+a.z*b.z;
}

vec3 crossProduct(vec3 a,vec3 b)
{
	vec3 c = vec3(a.y*b.z - a.z*b.y, a.z*b.x - a.x*b.z, a.x*b.y- a.y*b.x);

	return c;
}

float scalarTripleProduct(vec3 a,vec3 b,vec3 c)
{
	return dotProduct(a,crossProduct(b,c));
}

vec3 vectorTripleProduct(vec3 a,vec3 b,vec3 c)
{
	return crossProduct(a,crossProduct(b,c));
}
