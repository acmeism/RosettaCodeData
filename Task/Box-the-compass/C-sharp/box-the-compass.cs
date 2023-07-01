using System;
using System.Collections.Generic;

namespace BoxTheCompass
{
    class Compass
    {
        string[] cp = new string[] {"North", "North by east", "North-northeast", "Northeast by north", "Northeast","Northeast by east",
	    "East-northeast", "East by north", "East", "East by south", "East-southeast", "Southeast by east", "Southeast",
            "Southeast by south", "South-southeast", "South by east", "South", "South by west", "South-southwest", "Southwest by south",
            "Southwest", "Southwest by west", "West-southwest", "West by south", "West", "West by north", "West-northwest",
            "Northwest by west", "Northwest", "Northwest by north", "North-northwest", "North by west", "North"};

        public void compassHeading(float a)
        {
            int h = Convert.ToInt32(Math.Floor(a / 11.25f + .5f)) % 32;
            Console.WriteLine( "{0,2}: {1,-22} : {2,6:N}",h + 1, cp[h], a );
        }
    };
    class Program
    {
        static void Main(string[] args)
       {
            Compass c = new Compass();
            float[] degs = new float[] {0.0f, 16.87f, 16.88f, 33.75f, 50.62f, 50.63f, 67.5f, 84.37f, 84.38f, 101.25f,
                118.12f, 118.13f, 135.0f, 151.87f, 151.88f, 168.75f, 185.62f, 185.63f, 202.5f, 219.37f, 219.38f, 236.25f,
                253.12f, 253.13f, 270.0f, 286.87f, 286.88f, 303.75f, 320.62f, 320.63f, 337.5f, 354.37f, 354.38f};

            foreach (float d in degs)
                c.compassHeading(d);

            Console.WriteLine("\nPress any key to continue...");
            Console.ReadKey();
        }
    }
}
