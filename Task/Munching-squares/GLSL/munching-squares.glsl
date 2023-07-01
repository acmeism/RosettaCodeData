vec3 color;
float c,p;
vec2 b;

void main(void)
{
	vec2 uv = gl_FragCoord.xy / iResolution.xy;
	float scale = iResolution.x / iResolution.y;
	uv = uv-0.5;
	uv.y/=scale;
	
	b    = uv*256.0+256.0;
	c = 0.0;
	
	
	for(float i=16.0;i>=1.0;i-=1.0)
	{
		p = pow(2.0,i);

		if((p < b.x) ^^
		   (p < b.y))
		{
			c += p;
		}
		
		if(p < b.x)
		{
			b.x -= p;
		}
		
		if(p < b.y)
		{
			b.y -= p;
		}
		
	}
	
	c=mod(c/128.0,1.0);
	
	color = vec3(sin(c+uv.x*cos(uv.y*1.2)), tan(c+uv.y-0.3)*1.1, cos(c-uv.y+0.9));
	
	gl_FragColor = vec4(color,1.0);
}
