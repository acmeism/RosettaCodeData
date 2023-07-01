using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Test
{
    class Program
    {

        static void Main(string[] args)
        {
            /*
             * We Use Linq To Determine The Mode
             */
            List<int> myList = new List<int>() { 1, 1, 2, 4, 4 };

            var query =     from numbers in myList //select the numbers
                            group numbers by numbers //group them together so we can get the count
                            into groupedNumbers
                            select new { Number = groupedNumbers.Key, Count = groupedNumbers.Count() }; //so we got a query
            //find the max of the occurence of the mode
            int max = query.Max(g => g.Count);
            IEnumerable<int> modes = query.Where(x => x.Count == max).Select(x => x.Number);//match the frequence and select the number
            foreach (var item in modes)
            {
                Console.WriteLine(item);
            }

            Console.ReadLine();
        }



    }


}
