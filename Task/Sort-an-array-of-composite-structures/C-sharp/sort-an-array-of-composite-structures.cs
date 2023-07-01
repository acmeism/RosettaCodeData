using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    struct Entry
    {
        public Entry(string name, double value) { Name = name; Value = value; }
        public string Name;
        public double Value;
    }

    static void Main(string[] args)
    {
        var Elements = new List<Entry>
        {
            new Entry("Krypton", 83.798), new Entry("Beryllium", 9.012182), new Entry("Silicon", 28.0855),
            new Entry("Cobalt", 58.933195), new Entry("Selenium", 78.96), new Entry("Germanium", 72.64)
        };

        var sortedElements = Elements.OrderBy(e => e.Name);

        foreach (Entry e in sortedElements)
            Console.WriteLine("{0,-11}{1}", e.Name, e.Value);
    }
}
