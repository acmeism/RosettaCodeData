using System;
using System.Collections;
namespace ElementaryCellularAutomaton
{
    class Automata
    {
        BitArray cells, ncells;
        const int MAX_CELLS = 19;

        public void run()
        {
            cells = new BitArray(MAX_CELLS);
            ncells = new BitArray(MAX_CELLS);
            while (true)
            {
                Console.Clear();
                Console.WriteLine("What Rule do you want to visualize");
                doRule(int.Parse(Console.ReadLine()));
                Console.WriteLine("Press any key to continue...");
                Console.ReadKey();
            }
        }

        private byte getCells(int index)
        {
            byte b;
            int i1 = index - 1,
                i2 = index,
                i3 = index + 1;

            if (i1 < 0) i1 = MAX_CELLS - 1;
            if (i3 >= MAX_CELLS) i3 -= MAX_CELLS;

            b = Convert.ToByte(
                4 * Convert.ToByte(cells.Get(i1)) +
                2 * Convert.ToByte(cells.Get(i2)) +
                Convert.ToByte(cells.Get(i3)));
            return b;
        }

        private string getBase2(int i)
        {
            string s = Convert.ToString(i, 2);
            while (s.Length < 8)
            { s = "0" + s; }
            return s;
        }

        private void doRule(int rule)
        {
            Console.Clear();
            string rl = getBase2(rule);
            cells.SetAll(false);
            ncells.SetAll(false);
            cells.Set(MAX_CELLS / 2, true);

            Console.WriteLine("Rule: " + rule + "\n----------\n");

            for (int gen = 0; gen < 51; gen++)
            {
                Console.Write("{0, 4}", gen + ": ");

                foreach (bool b in cells)
                    Console.Write(b ? "#" : ".");

                Console.WriteLine("");

                int i = 0;
                while (true)
                {
                    byte b = getCells(i);
                    ncells[i] = '1' == rl[7 - b] ? true : false;
                    if (++i == MAX_CELLS) break;
                }

                i = 0;
                foreach (bool b in ncells)
                    cells[i++] = b;
            }
            Console.WriteLine("");
        }

    };
    class Program
    {
        static void Main(string[] args)
        {
            Automata t = new Automata();
            t.run();
        }
    }
}
