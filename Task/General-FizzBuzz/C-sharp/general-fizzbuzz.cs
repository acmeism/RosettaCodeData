using System;

public class GeneralFizzBuzz
{
    public static void Main()
    {
        int i;
        int j;
        int k;

        int limit;

        string iString;
        string jString;
        string kString;

        Console.WriteLine("First integer:");
        i = Convert.ToInt32(Console.ReadLine());
        Console.WriteLine("First string:");
        iString = Console.ReadLine();

        Console.WriteLine("Second integer:");
        j = Convert.ToInt32(Console.ReadLine());
        Console.WriteLine("Second string:");
        jString = Console.ReadLine();

        Console.WriteLine("Third integer:");
        k = Convert.ToInt32(Console.ReadLine());
        Console.WriteLine("Third string:");
        kString = Console.ReadLine();

        Console.WriteLine("Limit (inclusive):");
        limit = Convert.ToInt32(Console.ReadLine());

        for(int n = 1; n<= limit; n++)
        {
            bool flag = true;
            if(n%i == 0)
            {
                Console.Write(iString);
                flag = false;
            }

            if(n%j == 0)
            {
                Console.Write(jString);
                flag = false;
            }

            if(n%k == 0)
            {
                Console.Write(kString);
                flag = false;
            }
            if(flag)
                Console.Write(n);
            Console.WriteLine();
        }
    }
}
