using Amb;
using System;
using System.Collections.Generic;
using System.Linq;
using static System.Console;

static class ZebraProgram
{
    public static void Main()
    {
        var amb = new Amb.Amb();

        var domain = new[] { 1, 2, 3, 4, 5 };
        var terms = new Dictionary<IValue<int>, string>();
        IValue<int> Term(string name)
        {
            var x = amb.Choose(domain);
            terms.Add(x, name);
            return x;
        };

        void IsUnequal(params IValue<int>[] values) =>amb.Require(() => values.Select(v => v.Value).Distinct().Count() == 5);
        void IsSame(IValue<int> left, IValue<int> right) => amb.Require(() => left.Value == right.Value);
        void IsLeftOf(IValue<int> left, IValue<int> right) => amb.Require(() => right.Value - left.Value == 1);
        void IsIn(IValue<int> attrib, int house) => amb.Require(() => attrib.Value == house);
        void IsNextTo(IValue<int> left, IValue<int> right) => amb.Require(() => Math.Abs(left.Value - right.Value) == 1);

        IValue<int> english = Term("Englishman"), swede = Term("Swede"), dane = Term("Dane"), norwegian = Term("Norwegian"), german = Term("German");
        IsIn(norwegian, 1);
        IsUnequal(english, swede, german, dane, norwegian);

        IValue<int> red = Term("red"), green = Term("green"), white = Term("white"), blue = Term("blue"), yellow = Term("yellow");
        IsUnequal(red, green, white, blue, yellow);
        IsNextTo(norwegian, blue);
        IsLeftOf(green, white);
        IsSame(english, red);

        IValue<int> tea = Term("tea"), coffee = Term("coffee"), milk = Term("milk"), beer = Term("beer"), water = Term("water");
        IsIn(milk, 3);
        IsUnequal(tea, coffee, milk, beer, water);
        IsSame(dane, tea);
        IsSame(green, coffee);

        IValue<int> dog = Term("dog"), birds = Term("birds"), cats = Term("cats"), horse = Term("horse"), zebra = Term("zebra");
        IsUnequal(dog, cats, birds, horse, zebra);
        IsSame(swede, dog);

        IValue<int> pallmall = Term("pallmall"), dunhill = Term("dunhill"), blend = Term("blend"), bluemaster = Term("bluemaster"),prince = Term("prince");
        IsUnequal(pallmall, dunhill, bluemaster, prince, blend);
        IsSame(pallmall, birds);
        IsSame(dunhill, yellow);
        IsNextTo(blend, cats);
        IsNextTo(horse, dunhill);
        IsSame(bluemaster, beer);
        IsSame(german, prince);
        IsNextTo(water, blend);

        if (!amb.Disambiguate())
        {
            WriteLine("No solution found.");
            Read();
            return;
        }

        var h = new List<string>[5];
        for (int i = 0; i < 5; i++)
            h[i] = new List<string>();

        foreach (var (key, value) in terms.Select(kvp => (kvp.Key, kvp.Value)))
        {
            h[key.Value - 1].Add(value);
        }

        var owner = String.Concat(h.Where(l => l.Contains("zebra")).Select(l => l[0]));
        WriteLine($"The {owner} owns the zebra");

        foreach (var house in h)
        {
            Write("|");
            foreach (var attrib in house)
                Write($"{attrib,-10}|");
            Write("\n");
        }
        Read();
    }
}
