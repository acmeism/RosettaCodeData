static void Main(string[] args)
{
	Console.WriteLine(NthRoot(81,2,.001));
        Console.WriteLine(NthRoot(1000,3,.001));
        Console.ReadLine();
}

public static double NthRoot(double A,int n,  double p)
{
	double _n= (double) n;
	double[] x = new double[2];		
	x[0] = A;
	x[1] = A/_n;
	while(Math.Abs(x[0] -x[1] ) > p)
	{
		x[1] = x[0];
		x[0] = (1/_n)*(((_n-1)*x[1]) + (A/Math.Pow(x[1],_n-1)));
			
	}
	return x[0];
}
