using System;

public class RepString
{
    static readonly string[] input = {"1001110011", "1110111011", "0010010010",
        "1010101010", "1111111111", "0100101101", "0100100", "101", "11",
        "00", "1", "0100101"};

    public static void Main(string[] args)
    {
        foreach (string s in input)
            Console.WriteLine($"{s} : {repString(s)}");
    }

    static string repString(string s)
    {
        int len = s.Length;
        for (int part = len / 2; part > 0; part--)
        {
            int tail = len % part;
            if (tail > 0 && !s.Substring(0, tail).Equals(s.Substring(len - tail)))
                continue;
            bool isRepeated = true;
            for (int j = 0; j < len / part - 1; j++)
            {
                int a = j * part;
                int b = (j + 1) * part;
                int c = (j + 2) * part;
                if (!s.Substring(a, part).Equals(s.Substring(b, part)))
                {
                    isRepeated = false;
                    break;
                }
            }
            if (isRepeated)
                return s.Substring(0, part);
        }
        return "none";
    }
}
