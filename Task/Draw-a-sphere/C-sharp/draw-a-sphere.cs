using System;

namespace Sphere {
    internal class Program {
        private const string Shades = ".:!*oe%&#@";
        private static readonly double[] Light = {30, 30, -50};

        private static void Normalize(double[] v) {
            double len = Math.Sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
            v[0] /= len;
            v[1] /= len;
            v[2] /= len;
        }

        private static double Dot(double[] x, double[] y) {
            double d = x[0]*y[0] + x[1]*y[1] + x[2]*y[2];
            return d < 0 ? -d : 0;
        }

        public static void DrawSphere(double r, double k, double ambient) {
            var vec = new double[3];
            for(var i = (int)Math.Floor(-r); i <= (int)Math.Ceiling(r); i++) {
                double x = i + .5;
                for(var j = (int)Math.Floor(-2*r); j <= (int)Math.Ceiling(2*r); j++) {
                    double y = j/2.0 + .5;
                    if(x*x + y*y <= r*r) {
                        vec[0] = x;
                        vec[1] = y;
                        vec[2] = Math.Sqrt(r*r - x*x - y*y);
                        Normalize(vec);
                        double b = Math.Pow(Dot(Light, vec), k) + ambient;
                        int intensity = (b <= 0)
                                            ? Shades.Length - 2
                                            : (int)Math.Max((1 - b)*(Shades.Length - 1), 0);
                        Console.Write(Shades[intensity]);
                    }
                    else
                        Console.Write(' ');
                }
                Console.WriteLine();
            }
        }

        private static void Main() {
            Normalize(Light);
            DrawSphere(6, 4, .1);
            DrawSphere(10, 2, .4);
            Console.ReadKey();
        }
    }
}
