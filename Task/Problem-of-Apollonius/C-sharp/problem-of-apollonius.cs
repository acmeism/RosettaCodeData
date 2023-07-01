using System;

namespace ApolloniusProblemCalc
{
    class Program
    {
        static float rs = 0;
        static float xs = 0;
        static float ys = 0;

        public static void Main(string[] args)
        {
            float gx1;
            float gy1;
            float gr1;
            float gx2;
            float gy2;
            float gr2;
            float gx3;
            float gy3;
            float gr3;

            //----------Enter values for the given circles here----------
            gx1 = 0;
            gy1 = 0;
            gr1 = 1;
            gx2 = 4;
            gy2 = 0;
            gr2 = 1;
            gx3 = 2;
            gy3 = 4;
            gr3 = 2;
            //-----------------------------------------------------------

            for (int i = 1; i <= 8; i++)
            {
                SolveTheApollonius(i, gx1, gy1, gr1, gx2, gy2, gr2, gx3, gy3, gr3);


                if (i == 1)
                {
                    Console.WriteLine("X of point of the " + i + "st solution: " + xs.ToString());
                    Console.WriteLine("Y of point of the " + i + "st solution: " + ys.ToString());
                    Console.WriteLine(i + "st Solution circle's radius: " + rs.ToString());
                }
                else if (i == 2)
                {
                    Console.WriteLine("X of point of the " + i + "ed solution: " + xs.ToString());
                    Console.WriteLine("Y of point of the " + i + "ed solution: " + ys.ToString());
                    Console.WriteLine(i + "ed Solution circle's radius: " + rs.ToString());
                }
                else if(i == 3)
                {
                    Console.WriteLine("X of point of the " + i + "rd solution: " + xs.ToString());
                    Console.WriteLine("Y of point of the " + i + "rd solution: " + ys.ToString());
                    Console.WriteLine(i + "rd Solution circle's radius: " + rs.ToString());
                }
                else
                {
                    Console.WriteLine("X of point of the " + i + "th solution: " + xs.ToString());
                    Console.WriteLine("Y of point of the " + i + "th solution: " + ys.ToString());
                    Console.WriteLine(i + "th Solution circle's radius: " + rs.ToString());
                }

                Console.WriteLine();
            }


            Console.ReadKey(true);
        }

        private static void SolveTheApollonius(int calcCounter, float x1, float y1, float r1, float x2, float y2, float r2, float x3, float y3, float r3)
        {
            float s1 = 1;
            float s2 = 1;
            float s3 = 1;

            if (calcCounter == 2)
            {
                s1 = -1;
                s2 = -1;
                s3 = -1;
            }
            else if (calcCounter == 3)
            {
                s1 = 1;
                s2 = -1;
                s3 = -1;
            }
            else if (calcCounter == 4)
            {
                s1 = -1;
                s2 = 1;
                s3 = -1;
            }
            else if (calcCounter == 5)
            {
                s1 = -1;
                s2 = -1;
                s3 = 1;
            }
            else if (calcCounter == 6)
            {
                s1 = 1;
                s2 = 1;
                s3 = -1;
            }
            else if (calcCounter == 7)
            {
                s1 = -1;
                s2 = 1;
                s3 = 1;
            }
            else if (calcCounter == 8)
            {
                s1 = 1;
                s2 = -1;
                s3 = 1;
            }

            //This calculation to solve for the solution circles is cited from the Java version
            float v11 = 2 * x2 - 2 * x1;
            float v12 = 2 * y2 - 2 * y1;
            float v13 = x1 * x1 - x2 * x2 + y1 * y1 - y2 * y2 - r1 * r1 + r2 * r2;
            float v14 = 2 * s2 * r2 - 2 * s1 * r1;

            float v21 = 2 * x3 - 2 * x2;
            float v22 = 2 * y3 - 2 * y2;
            float v23 = x2 * x2 - x3 * x3 + y2 * y2 - y3 * y3 - r2 * r2 + r3 * r3;
            float v24 = 2 * s3 * r3 - 2 * s2 * r2;

            float w12 = v12 / v11;
            float w13 = v13 / v11;
            float w14 = v14 / v11;

            float w22 = v22 / v21 - w12;
            float w23 = v23 / v21 - w13;
            float w24 = v24 / v21 - w14;

            float P = -w23 / w22;
            float Q = w24 / w22;
            float M = -w12 * P - w13;
            float N = w14 - w12 * Q;

            float a = N * N + Q * Q - 1;
            float b = 2 * M * N - 2 * N * x1 + 2 * P * Q - 2 * Q * y1 + 2 * s1 * r1;
            float c = x1 * x1 + M * M - 2 * M * x1 + P * P + y1 * y1 - 2 * P * y1 - r1 * r1;

            float D = b * b - 4 * a * c;

            rs = (-b - float.Parse(Math.Sqrt(D).ToString())) / (2 * float.Parse(a.ToString()));
            xs = M + N * rs;
            ys = P + Q * rs;
        }
    }
}
