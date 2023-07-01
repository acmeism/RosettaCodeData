using System;

class Program
{
    static long TRIALS = 1000000L;
    private class Expv
    {
        public string name;
        public int probcount;
        public double expect;
        public double mapping;

        public Expv(string name, int probcount, double expect, double mapping)
        {
            this.name = name;
            this.probcount = probcount;
            this.expect = expect;
            this.mapping = mapping;
        }
    }

    static Expv[] items = {
        new Expv("aleph", 0, 0.0, 0.0), new Expv("beth", 0, 0.0, 0.0),
        new Expv("gimel", 0, 0.0, 0.0), new Expv("daleth", 0, 0.0, 0.0),
	new Expv("he", 0, 0.0, 0.0),    new Expv("waw", 0, 0.0, 0.0),
	new Expv("zayin", 0, 0.0, 0.0), new Expv("heth", 0, 0.0, 0.0)
    };

    static void Main(string[] args)
    {
        double rnum, tsum = 0.0;
        Random random = new Random();

        for (int i = 0, rnum = 5.0; i < 7; i++, rnum += 1.0)
        {
            items[i].expect = 1.0 / rnum;
            tsum += items[i].expect;
        }
        items[7].expect = 1.0 - tsum;

        items[0].mapping = 1.0 / 5.0;
        for (int i = 1; i < 7; i++)
            items[i].mapping = items[i - 1].mapping + 1.0 / ((double)i + 5.0);
        items[7].mapping = 1.0;

        for (int i = 0; i < TRIALS; i++)
        {
            rnum = random.NextDouble();
            for (int j = 0; j < 8; j++)
                if (rnum < items[j].mapping)
                {
                    items[j].probcount++;
                    break;
                }
        }

        Console.WriteLine("Trials: {0}", TRIALS);
        Console.Write("Items:          ");
        for (int i = 0; i < 8; i++)
            Console.Write(items[i].name.PadRight(9));
        Console.WriteLine();
        Console.Write("Target prob.:   ");
        for (int i = 0; i < 8; i++)
            Console.Write("{0:0.000000} ", items[i].expect);
        Console.WriteLine();
        Console.Write("Attained prob.: ");
        for (int i = 0; i < 8; i++)
            Console.Write("{0:0.000000} ", (double)items[i].probcount / (double)TRIALS);
        Console.WriteLine();
    }
}
