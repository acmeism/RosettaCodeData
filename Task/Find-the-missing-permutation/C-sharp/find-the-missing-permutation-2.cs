using System;
using System.Linq;

public class Test
{
    public static void Main()
    {
        var input = new [] {"ABCD","CABD","ACDB","DACB","BCDA",
            "ACBD","ADCB","CDAB","DABC","BCAD","CADB",
            "CDBA","CBAD","ABDC","ADBC","BDCA","DCBA",
            "BACD","BADC","BDAC","CBDA","DBCA","DCAB"};

        int[] values = {0,0,0,0};
        foreach (string s in input)
            for (int i = 0; i < 4; i++)
                values[i] ^= s[i];
        Console.WriteLine(string.Join("", values.Select(i => (char)i)));
    }
}
