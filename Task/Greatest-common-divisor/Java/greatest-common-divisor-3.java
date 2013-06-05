static int gcd(int a,int b)
	{
		int min=a>b?b:a,max=a+b-min, div=min;
		for(int i=1;i<min;div=min/++i)
			if(max%div==0)
				return div;
		return 1;
	}
