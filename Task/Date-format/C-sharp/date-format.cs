using System;

namespace RosettaCode.DateFormat
{
    class Program
    {
        static void Main(string[] args)
        {
            DateTime today = DateTime.Now.Date;
            Console.WriteLine(today.ToString("yyyy-MM-dd"));
            Console.WriteLine(today.ToString("dddd, MMMMM d, yyyy"));
        }
    }
}
