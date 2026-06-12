using System;
using System.Linq;

class OHalloranNumbers
{
    static void Main(string[] args)
    {
        int maximumArea = 1000;
        int halfMaximumArea = maximumArea / 2;

        bool[] ohalloranNumbers = Enumerable.Repeat(true, halfMaximumArea).ToArray();

        for (int length = 1; length < maximumArea; length++)
        {
            for (int width = 1; width < halfMaximumArea; width++)
            {
                for (int height = 1; height < halfMaximumArea; height++)
                {
                    int halfArea = length * width + length * height + width * height;
                    if (halfArea < halfMaximumArea)
                    {
                        ohalloranNumbers[halfArea] = false;
                    }
                }
            }
        }

        Console.WriteLine("Values larger than 6 and less than 1,000 which cannot be the surface area of a cuboid:");
        for (int i = 3; i < halfMaximumArea; i++)
        {
            if (ohalloranNumbers[i])
            {
                Console.Write(i * 2 + " ");
            }
        }
        Console.WriteLine();
    }
}
