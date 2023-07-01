using System.IO;
using System.Linq;

namespace CSV_data_manipulation
{
    class Program
    {
        static void Main()
        {
            var input = File.ReadAllLines("test_in.csv");
            var output = input.Select((line, i) =>
            {
                if (i == 0)
                    return line + ",SUM";
                var sum = line.Split(',').Select(int.Parse).Sum();
                return line + "," + sum;
            }).ToArray();
            File.WriteAllLines("test_out.csv", output);
        }
    }
}
