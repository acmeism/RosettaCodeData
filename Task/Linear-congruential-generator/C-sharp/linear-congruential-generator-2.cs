using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace FreeCellDeals
{
    public class LCG
    {
        private int _state;
        public bool Microsoft { get; set;}
        public bool BSD
        {
            get
            {
                return !Microsoft;
            }
            set
            {
                Microsoft = !value;
            }
        }

        public LCG(bool microsoft = true)
        {
            _state = (int)DateTime.Now.Ticks;
            Microsoft = microsoft;
        }

        public LCG(int n, bool microsoft = true)
        {
            _state = n;
            Microsoft = microsoft;
        }

        public int Next()
        {
            if (BSD)
            {
                return _state = (1103515245 * _state + 12345) & int.MaxValue;
            }
            return ((_state = 214013 * _state + 2531011) & int.MaxValue) >> 16;
        }

        public IEnumerable<int> Seq()
        {
            while (true)
            {
                yield return Next();
            }
        }
    }

    class Program
    {
        static void Main()
        {
            LCG ms = new LCG(0, true);
            LCG bsd = new LCG(0,false);
            Console.WriteLine("Microsoft");
            ms.Seq().Take(10).ToList().ForEach(Console.WriteLine);
            Console.WriteLine("\nBSD");
            bsd.Seq().Take(10).ToList().ForEach(Console.WriteLine);
            Console.ReadKey();
        }
    }
}
