using System;
using System.Linq;

class Program
{
    static void Main(string[] args)
    {
        Enumerable.Range(2008, 113).ToList()
        .ConvertAll(ent => new DateTime(ent, 12, 25))
        .Where(ent => ent.DayOfWeek.Equals(DayOfWeek.Sunday)).ToList()
        .ForEach(ent => Console.WriteLine(ent.ToString("dd MMM yyyy")));
    }
}
