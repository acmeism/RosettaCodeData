using System;
using System.Collections.Generic;
using static System.Linq.Enumerable;

public static class SetPuzzle
{
    static readonly Feature[] numbers  = { (1, "One"), (2, "Two"), (3, "Three") };
    static readonly Feature[] colors   = { (1, "Red"), (2, "Green"), (3, "Purple") };
    static readonly Feature[] shadings = { (1, "Open"), (2, "Striped"), (3, "Solid") };
    static readonly Feature[] symbols  = { (1, "Oval"), (2, "Squiggle"), (3, "Diamond") };

    private readonly struct Feature
    {
        public Feature(int value, string name) => (Value, Name) = (value, name);
        public int Value { get; }
        public string Name { get; }
        public static implicit operator int(Feature f) => f.Value;
        public static implicit operator Feature((int value, string name) t) => new Feature(t.value, t.name);
        public override string ToString() => Name;
    }

    private readonly struct Card : IEquatable<Card>
    {
        public Card(Feature number, Feature color, Feature shading, Feature symbol) =>
            (Number, Color, Shading, Symbol) = (number, color, shading, symbol);

        public Feature Number { get; }
        public Feature Color { get; }
        public Feature Shading { get; }
        public Feature Symbol { get; }

        public override string ToString() => $"{Number} {Color} {Shading} {Symbol}(s)";
        public bool Equals(Card other) => Number == other.Number && Color == other.Color && Shading == other.Shading && Symbol == other.Symbol;
    }

    public static void Main() {
        Card[] deck = (
            from number in numbers
            from color in colors
            from shading in shadings
            from symbol in symbols
            select new Card(number, color, shading, symbol)
        ).ToArray();
        var random = new Random();

        Deal(deck, 9, 4, random);
        Console.WriteLine();
        Console.WriteLine();
        Deal(deck, 12, 6, random);
    }

    static void Deal(Card[] deck, int size, int target, Random random) {
        List<(Card a, Card b, Card c)> sets;
        do {
            Shuffle(deck, random.Next);
            sets = (
                from i in 0.To(size - 2)
                from j in (i + 1).To(size - 1)
                from k in (j + 1).To(size)
                select (deck[i], deck[j], deck[k])
            ).Where(IsSet).ToList();
        } while (sets.Count != target);
        Console.WriteLine("The board:");
        foreach (Card card in deck.Take(size)) Console.WriteLine(card);
        Console.WriteLine();
        Console.WriteLine("Sets:");
        foreach (var s in sets) Console.WriteLine(s);
    }

    static void Shuffle<T>(T[] array, Func<int, int, int> rng) {
        for (int i = 0; i < array.Length; i++) {
            int r = rng(i, array.Length);
            (array[r], array[i]) = (array[i], array[r]);
        }
    }

    static bool IsSet((Card a, Card b, Card c) t) =>
        AreSameOrDifferent(t.a.Number, t.b.Number, t.c.Number) &&
        AreSameOrDifferent(t.a.Color, t.b.Color, t.c.Color) &&
        AreSameOrDifferent(t.a.Shading, t.b.Shading, t.c.Shading) &&
        AreSameOrDifferent(t.a.Symbol, t.b.Symbol, t.c.Symbol);

    static bool AreSameOrDifferent(int a, int b, int c) => (a + b + c) % 3 == 0;
    static IEnumerable<int> To(this int start, int end) => Range(start, end - start - 1);
}
