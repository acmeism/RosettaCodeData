using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace TextProc3
{
    class Program
    {
        static void Main(string[] args)
        {
            string line;
            int count = 0, maxcount = 0;
            List<string> times = new List<string>();
            System.IO.StreamReader file = new StreamReader("mlijobs.txt");
            while ((line = file.ReadLine()) != null)
            {
                string[] lineelements = line.Split(' ');
                switch (lineelements[1])
                {
                    case "IN":
                        count--;
                        break;
                    case "OUT":
                        count++;
                        if (count > maxcount)
                        {
                            maxcount = count;
                            times.Clear();
                            times.Add(lineelements[3]);
                        }else if(count == maxcount){
                            times.Add(lineelements[3]);
                        }
                        break;
                }
            }
            file.Close();
            Console.WriteLine(maxcount);
            foreach (string time in times)
            {
                Console.WriteLine(time);
            }
        }
    }
}
