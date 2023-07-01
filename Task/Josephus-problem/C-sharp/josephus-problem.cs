namespace Josephus
{
    using System;
    using System.Collections;
    using System.Collections.Generic;

    public class Program
    {
        public static int[] JosephusProblem(int n, int m)
        {
            var circle = new List<int>();
            var order = new int[n];

            for (var i = 0; i < n; ++i)
            {
                circle.Add(i);
            }

            var l = 0;
            var j = 0;
            var k = 0;

            while (circle.Count != 0)
            {
                j++;
                if (j == m)
                {
                    order[k] = circle[l];
                    circle.RemoveAt(l);

                    k++;
                    l--;
                    j = 0;
                }

                if (k == n - 1)
                {
                    order[k] = circle[0];
                    circle.RemoveAt(0);
                }

                if (l == circle.Count - 1)
                {
                    l = 0;
                }
                else
                {
                    l++;
                }
            }

            return order;
        }

        static void Main(string[] args)
        {
            try
            {
                var n = 7;
                var m = 2;

                var result = JosephusProblem(n, m);

               for (var i = 0; i < result.Length; i++)
               {
                   Console.WriteLine(result[i]);//1 3 5 0 4 2 6
               }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
            finally
            {
                Console.ReadLine();
            }
        }

    }
}
