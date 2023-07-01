using System;
using System.Linq;

namespace Test
{
    class Program
    {
        static void Main()
        {
            double[] myArr = new double[] { 1, 5, 3, 6, 4, 2 };

            myArr = myArr.OrderBy(i => i).ToArray();
            // or Array.Sort(myArr) for in-place sort

            int mid = myArr.Length / 2;
            double median;

            if (myArr.Length % 2 == 0)
            {
                //we know its even
                median = (myArr[mid] + myArr[mid - 1]) / 2.0;
            }
            else
            {
                //we know its odd
                median = myArr[mid];
            }

            Console.WriteLine(median);
            Console.ReadLine();
        }
    }
}
