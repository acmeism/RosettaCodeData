using System;
using System.Collections.Generic;

namespace AssocArrays
{
    class Program
    {
        static void Main(string[] args)
        {

            Dictionary<string,int> assocArray = new Dictionary<string,int>();

            assocArray["Hello"] = 1;
            assocArray.Add("World", 2);
            assocArray["!"] = 3;

            foreach (KeyValuePair<string, int> kvp in assocArray)
            {
                Console.WriteLine(kvp.Key + " : " + kvp.Value);
            }

            foreach (string key in assocArray.Keys)
            {
                Console.WriteLine(key);
            }

            foreach (int val in assocArray.Values)
            {
                Console.WriteLine(val.ToString());
            }
        }
    }
}
