using System;
using System.Text;
using System.Linq;

class Program
{
    static string lookandsay(string number)
    {
        StringBuilder result = new StringBuilder();

        char repeat = number[0];
        number = number.Substring(1, number.Length-1)+" ";
        int times = 1;

        foreach (char actual in number)
        {
            if (actual != repeat)
            {
                result.Append(Convert.ToString(times)+repeat);
                times = 1;
                repeat = actual;
            }
            else
            {
                times += 1;
            }
        }
        return result.ToString();
    }

    static void Main(string[] args)
    {
        string num = "1";

        foreach (int i in Enumerable.Range(1, 10)) {
             Console.WriteLine(num);
             num = lookandsay(num);
        }
    }
}
