using System;

namespace RungeKutta
{
    class Program
    {
        static void Main(string[] args)
        {
            //Incrementers to pass into the known solution
            double t = 0.0;
            double T = 10.0;
            double dt = 0.1;

            // Assign the number of elements needed for the arrays
            int n = (int)(((T - t) / dt)) + 1;

            // Initialize the arrays for the time index 's' and estimates 'y' at each index 'i'
            double[] y = new double[n];
            double[] s = new double[n];

            // RK4 Variables
            double dy1;
            double dy2;
            double dy3;
            double dy4;

            // RK4 Initializations
            int i = 0;
            s[i] = 0.0;
            y[i] = 1.0;

            Console.WriteLine(" ===================================== ");
            Console.WriteLine(" Beging 4th Order Runge Kutta Method ");
            Console.WriteLine(" ===================================== ");

            Console.WriteLine();
            Console.WriteLine(" Given the example Differential equation: \n");
            Console.WriteLine("     y' = t*sqrt(y) \n");
            Console.WriteLine(" With the initial conditions: \n");
            Console.WriteLine("     t0 = 0" + ", y(0) = 1.0 \n");
            Console.WriteLine(" Whose exact solution is known to be: \n");
            Console.WriteLine("     y(t) = 1/16*(t^2 + 4)^2 \n");
            Console.WriteLine(" Solve the given equations over the range t = 0...10 with a step value dt = 0.1 \n");
            Console.WriteLine(" Print the calculated values of y at whole numbered t's (0.0,1.0,...10.0) along with the error \n");
            Console.WriteLine();

            Console.WriteLine(" y(t) " +"RK4" + " ".PadRight(18) + "Absolute Error");
            Console.WriteLine(" -------------------------------------------------");
            Console.WriteLine(" y(0) " + y[i] + " ".PadRight(20) + (y[i] - solution(s[i])));

            // Iterate and implement the Rk4 Algorithm
            while (i < y.Length - 1)
            {

                dy1 = dt * equation(s[i], y[i]);
                dy2 = dt * equation(s[i] + dt / 2, y[i] + dy1 / 2);
                dy3 = dt * equation(s[i] + dt / 2, y[i] + dy2 / 2);
                dy4 = dt * equation(s[i] + dt, y[i] + dy3);

                s[i + 1] = s[i] + dt;
                y[i + 1] = y[i] + (dy1 + 2 * dy2 + 2 * dy3 + dy4) / 6;

                double error = Math.Abs(y[i + 1] - solution(s[i + 1]));
                double t_rounded = Math.Round(t + dt, 2);

                if (t_rounded % 1 == 0)
                {
                    Console.WriteLine(" y(" + t_rounded + ")" + " " + y[i + 1] + " ".PadRight(5) + (error));
                }

                i++;
                t += dt;

            };//End Rk4

            Console.ReadLine();
        }

        // Differential Equation
        public static double equation(double t, double y)
        {
            double y_prime;
            return y_prime = t*Math.Sqrt(y);
        }

        // Exact Solution
        public static double solution(double t)
        {
            double actual;
            actual = Math.Pow((Math.Pow(t, 2) + 4), 2)/16;
            return actual;
        }
    }
}
