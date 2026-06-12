using System;
using System.Collections.Generic;
using System.Linq;

namespace SyntheticDivision
{
    class Program
    {
        static (List<int>,List<int>) extendedSyntheticDivision(List<int> dividend, List<int> divisor)
        {
            List<int> output = dividend.ToList();
            int normalizer = divisor[0];

            for (int i = 0; i < dividend.Count() - (divisor.Count() - 1); i++)
            {
                output[i] /= normalizer;

                int coef = output[i];
                if (coef != 0)
                {
                    for (int j = 1; j < divisor.Count(); j++)
                        output[i + j] += -divisor[j] * coef;
                }
            }

            int separator = output.Count() - (divisor.Count() - 1);

            return (
                output.GetRange(0, separator),
                output.GetRange(separator, output.Count() - separator)
            );
        }

        static void Main(string[] args)
        {
            List<int> N = new List<int>{ 1, -12, 0, -42 };
            List<int> D = new List<int> { 1, -3 };

            var (quotient, remainder) = extendedSyntheticDivision(N, D);
            Console.WriteLine("[ {0} ] / [ {1} ] = [ {2} ], remainder [ {3} ]" ,
                string.Join(",", N),
                string.Join(",", D),
                string.Join(",", quotient),
                string.Join(",", remainder)
            );
        }
    }
}
