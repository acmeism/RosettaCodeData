using System;
using System.Numerics;

static int g = 7;
static double[] p = {0.99999999999980993, 676.5203681218851, -1259.1392167224028,
	     771.32342877765313, -176.61502916214059, 12.507343278686905,
	     -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7};
		
Complex Gamma(Complex z)
{
    // Reflection formula
    if (z.Real < 0.5)
	{
        return Math.PI / (Complex.Sin( Math.PI * z) * Gamma(1 - z));
	}
    else
	{
        z -= 1;
        Complex x = p[0];
        for (var i = 1; i < g + 2; i++)
		{
            x += p[i]/(z+i);
		}
        Complex t = z + g + 0.5;
        return Complex.Sqrt(2 * Math.PI) * (Complex.Pow(t, z + 0.5)) * Complex.Exp(-t) * x;
	}
}
