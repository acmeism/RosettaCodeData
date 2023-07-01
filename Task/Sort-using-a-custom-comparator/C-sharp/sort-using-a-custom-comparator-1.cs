using System;
using System.Collections.Generic;

namespace RosettaCode {
    class SortCustomComparator {
        // Driver program
        public void CustomSort() {
            String[] items = { "Here", "are", "some", "sample", "strings", "to", "be", "sorted" };
            List<String> list = new List<string>(items);

            DisplayList("Unsorted", list);

            list.Sort(CustomCompare);
            DisplayList("Descending Length", list);

            list.Sort();
            DisplayList("Ascending order", list);
        }

        // Custom compare
        public int CustomCompare(String x, String y) {
            int result = -x.Length.CompareTo(y.Length);
            if (result == 0) {
                result = x.ToLower().CompareTo(y.ToLower());
            }

            return result;
        }

        // Output routine
        public void DisplayList(String header, List<String> theList) {
            Console.WriteLine(header);
            Console.WriteLine("".PadLeft(header.Length, '*'));
            foreach (String str in theList) {
                Console.WriteLine(str);
            }
            Console.WriteLine();
        }
    }
}
