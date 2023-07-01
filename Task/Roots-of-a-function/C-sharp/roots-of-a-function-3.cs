using System;

class Program
{
    public static void Main(string[] args)
    {
        Func<double, double> f = x => { return x * x * x - 3 * x * x + 2 * x; };
        double root = BrentsFun(f, lower: -1.0, upper: 4, tol: 0.002, maxIter: 100);
    }

    private static void Swap<T>(ref T a, ref T b)
    {
        var tmp = a;
        a = b;
        b = tmp;
    }

    public static double BrentsFun(Func<double, double> f, double lower, double upper, double tol, uint maxIter)
    {
        double a = lower;
        double b = upper;
        double fa = f(a); // calculated now to save function calls
        double fb = f(b); // calculated now to save function calls
        double fs;

        if (!(fa * fb < 0))
            throw new ArgumentException("Signs of f(lower_bound) and f(upper_bound) must be opposites");

        if (Math.Abs(fa) < Math.Abs(b)) // if magnitude of f(lower_bound) is less than magnitude of f(upper_bound)
        {
            Swap(ref a, ref b);
            Swap(ref fa, ref fb);
        }

        double c = a;      // c now equals the largest magnitude of the lower and upper bounds
        double fc = fa;    // precompute function evalutation for point c by assigning it the same value as fa
        bool mflag = true; // boolean flag used to evaluate if statement later on
        double s = 0;      // Our Root that will be returned
        double d = 0;      // Only used if mflag is unset (mflag == false)

        for (uint iter = 1; iter < maxIter; ++iter)
        {
            // stop if converged on root or error is less than tolerance
            if (Math.Abs(b - a) < tol)
            {
                Console.WriteLine("After {0} iterations the root is: {1}", iter, s);
                return s;
            } // end if

            if (fa != fc && fb != fc)
            {
                // use inverse quadratic interopolation
                s =   (a * fb * fc / ((fa - fb) * (fa - fc)))
                    + (b * fa * fc / ((fb - fa) * (fb - fc)))
                    + (c * fa * fb / ((fc - fa) * (fc - fb)));
            }
            else
            {
                // secant method
                s = b - fb * (b - a) / (fb - fa);
            }

            // checks to see whether we can use the faster converging quadratic && secant methods or if we need to use bisection
            if (    ( (s < (3 * a + b) * 0.25) || (s > b)) ||
                    (  mflag && (Math.Abs(s - b) >= (Math.Abs(b - c) * 0.5)) ) ||
                    ( !mflag && (Math.Abs(s - b) >= (Math.Abs(c - d) * 0.5)) ) ||
                    (  mflag && (Math.Abs(b - c) < tol) ) ||
                    ( !mflag && (Math.Abs(c - d) < tol))    )
            {
                // bisection method
                s = (a + b) * 0.5;

                mflag = true;
            }
            else
            {
                mflag = false;
            }

            fs = f(s);// calculate fs
            d = c;    // first time d is being used (wasnt used on first iteration because mflag was set)
            c = b;    // set c equal to upper bound
            fc = fb;  // set f(c) = f(b)

            if (fa * fs < 0) // fa and fs have opposite signs
            {
                b = s;
                fb = fs; // set f(b) = f(s)
            }
            else
            {
                a = s;
                fa = fs; // set f(a) = f(s)
            }

            if (Math.Abs(fa) < Math.Abs(fb)) // if magnitude of fa is less than magnitude of fb
            {
                Swap(ref a, ref b);          // swap a and b
                Swap(ref fa, ref fb); // make sure f(a) and f(b) are correct after swap
            }
        } // end for

        throw new AggregateException("The solution does not converge or iterations are not sufficient");
    }
    // end brents_fun
}
