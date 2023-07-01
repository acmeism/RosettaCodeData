using System;
using System.Collections.Generic;

namespace heron
{
    class Program{
        static void Main(string[] args){
            List<int[]> list = new List<int[]>();
            for (int c = 1; c <= 200; c++)
                for (int b = 1; b <= c; b++)
                    for (int a = 1; a <= b; a++)
                        if (gcd(a, gcd(b, c)) == 1 && isHeron(heronArea(a, b, c)))
                            list.Add(new int[] { a, b, c, a + b + c, (int)heronArea(a, b, c)});
            sort(list);
            Console.WriteLine("Number of primitive Heronian triangles with sides up to 200: " + list.Count + "\n\nFirst ten when ordered by increasing area, then perimeter,then maximum sides:\nSides\t\t\tPerimeter\tArea");
            for(int i = 0; i < 10; i++)
                Console.WriteLine(list[i][0] + "\t" + list[i][1] + "\t" + list[i][2] + "\t" + list[i][3] + "\t\t" + list[i][4]);
            Console.WriteLine("\nPerimeter = 210\nSides\t\t\tPerimeter\tArea");
            foreach (int[] i in list)
                if (i[4] == 210)
                    Console.WriteLine(i[0] + "\t" + i[1] + "\t" + i[2] + "\t" + i[3] + "\t\t" + i[4]);
        }
        static bool isHeron(double heronArea){
            return heronArea % 1 == 0 && heronArea != 0;
        }
        static double heronArea(int a, int b, int c){
            double s = (a + b + c) / 2d;
            return Math.Sqrt(s * (s - a) * (s - b) * (s - c));
        }
        static int gcd(int a, int b){
            int remainder = 1, dividend, divisor;
            dividend = a > b ? a : b;
            divisor = a > b ? b : a;
            while (remainder != 0){
                remainder = dividend % divisor;
                if (remainder != 0){
                    dividend = divisor;
                    divisor = remainder;
                }
            }
            return divisor;
        }
        static void sort(List<int[]> list){
            int[] temp = new int[5];
            bool changed = true;
            while(changed){
                changed = false;
                for (int i = 1; i < list.Count; i++)
                    if (list[i][4] < list[i - 1][4] || list[i][4] == list[i - 1][4] && list[i][3] < list[i - 1][3]){
                        temp = list[i];
                        list[i] = list[i - 1];
                        list[i - 1] = temp;
                        changed = true;
                    }
            }
        }
    }
}
