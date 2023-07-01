using System;
using System.Collections.Generic;
using static System.Linq.Enumerable;

public static class Solve24Game
{
    public static void Main2() {
        var testCases = new [] {
            new [] { 1,1,2,7 },
            new [] { 1,2,3,4 },
            new [] { 1,2,4,5 },
            new [] { 1,2,7,7 },
            new [] { 1,4,5,6 },
            new [] { 3,3,8,8 },
            new [] { 4,4,5,9 },
            new [] { 5,5,5,5 },
            new [] { 5,6,7,8 },
            new [] { 6,6,6,6 },
            new [] { 6,7,8,9 },
        };
        foreach (var t in testCases) Test(24, t);
        Test(100, 9,9,9,9,9,9);

        static void Test(int target, params int[] numbers) {
            foreach (var eq in GenerateEquations(target, numbers)) Console.WriteLine(eq);
            Console.WriteLine();
        }
    }

    static readonly char[] ops = { '*', '/', '+', '-' };
    public static IEnumerable<string> GenerateEquations(int target, params int[] numbers) {
        var operators = Repeat(ops, numbers.Length - 1).CartesianProduct().Select(e => e.ToArray()).ToList();
        return (
            from pattern in Patterns(numbers.Length)
            let expression = CreateExpression(pattern)
            from ops in operators
            where expression.WithOperators(ops).HasPreferredTree()
            from permutation in Permutations(numbers)
            let expr = expression.WithValues(permutation)
            where expr.Value == target && expr.HasPreferredValues()
            select $"{expr.ToString()} = {target}")
            .Distinct()
            .DefaultIfEmpty($"Cannot make {target} with {string.Join(", ", numbers)}");
    }

    ///<summary>Generates postfix expression trees where 1's represent operators and 0's represent numbers.</summary>
    static IEnumerable<int> Patterns(int length) {
        if (length == 1) yield return 0; //0
        if (length == 2) yield return 1; //001
        if (length < 3) yield break;
        //Of each tree, the first 2 bits must always be 0 and the last bit must be 1. Generate the bits in between.
        length -= 2;
        int len = length * 2 + 3;
        foreach (int permutation in BinaryPatterns(length, length * 2)) {
            (int p, int l) = ((permutation << 1) + 1, len);
            if (IsValidPattern(ref p, ref l)) yield return (permutation << 1) + 1;
        }
    }

    ///<summary>Generates all numbers with the given number of 1's and total length.</summary>
    static IEnumerable<int> BinaryPatterns(int ones, int length) {
        int initial = (1 << ones) - 1;
        int blockMask = (1 << length) - 1;
        for (int v = initial; v >= initial; ) {
            yield return v;
            int w = (v | (v - 1)) + 1;
            w |= (((w & -w) / (v & -v)) >> 1) - 1;
            v = w & blockMask;
        }
    }

    static bool IsValidPattern(ref int pattern, ref int len) {
        bool isNumber = (pattern & 1) == 0;
        pattern >>= 1;
        len--;
        if (isNumber) return true;
        IsValidPattern(ref pattern, ref len);
        IsValidPattern(ref pattern, ref len);
        return len == 0;
    }

    static Expr CreateExpression(int pattern) {
        return Create();

        Expr Create() {
            bool isNumber = (pattern & 1) == 0;
            pattern >>= 1;
            if (isNumber) return new Const(0);
            Expr right = Create();
            Expr left = Create();
            return new Binary('*', left, right);
        }
    }

    static IEnumerable<IEnumerable<T>> CartesianProduct<T>(this IEnumerable<IEnumerable<T>> sequences) {
        IEnumerable<IEnumerable<T>> emptyProduct = new[] { Empty<T>() };
        return sequences.Aggregate(
            emptyProduct,
            (accumulator, sequence) =>
                from acc in accumulator
                from item in sequence
                select acc.Concat(new [] { item }));
    }

    private static List<int> helper = new List<int>();
    public static IEnumerable<T[]> Permutations<T>(params T[] input) {
        if (input == null || input.Length == 0) yield break;
        helper.Clear();
        for (int i = 0; i < input.Length; i++) helper.Add(i);
        while (true) {
            yield return input;
            int cursor = helper.Count - 2;
            while (cursor >= 0 && helper[cursor] > helper[cursor + 1]) cursor--;
            if (cursor < 0) break;
            int i = helper.Count - 1;
            while (i > cursor && helper[i] < helper[cursor]) i--;
            (helper[cursor], helper[i]) = (helper[i], helper[cursor]);
            (input[cursor], input[i]) = (input[i], input[cursor]);
            int firstIndex = cursor + 1;
            for (int lastIndex = helper.Count - 1; lastIndex > firstIndex; ++firstIndex, --lastIndex) {
                (helper[firstIndex], helper[lastIndex]) = (helper[lastIndex], helper[firstIndex]);
                (input[firstIndex], input[lastIndex]) = (input[lastIndex], input[firstIndex]);
            }
        }
    }

    static Expr WithOperators(this Expr expr, char[] operators) {
        int i = 0;
        SetOperators(expr, operators, ref i);
        return expr;

        static void SetOperators(Expr expr, char[] operators, ref int i) {
            if (expr is Binary b) {
                b.Symbol = operators[i++];
                SetOperators(b.Right, operators, ref i);
                SetOperators(b.Left, operators, ref i);
            }
        }
    }

    static Expr WithValues(this Expr expr, int[] values) {
        int i = 0;
        SetValues(expr, values, ref i);
        return expr;

        static void SetValues(Expr expr, int[] values, ref int i) {
            if (expr is Binary b) {
                SetValues(b.Left, values, ref i);
                SetValues(b.Right, values, ref i);
            } else {
                expr.Value = values[i++];
            }
        }
    }

    static bool HasPreferredTree(this Expr expr) => expr switch {
        Const _ => true,

        // a / b * c => a * c / b
        ((_, '/' ,_), '*', _) => false,
        // c + a * b => a * b + c
        (var l, '+', (_, '*' ,_) r) when l.Depth < r.Depth => false,
        // c + a / b => a / b + c
        (var l, '+', (_, '/' ,_) r) when l.Depth < r.Depth => false,
        // a * (b + c) => (b + c) * a
        (var l, '*', (_, '+' ,_) r) when l.Depth < r.Depth => false,
        // a * (b - c) => (b - c) * a
        (var l, '*', (_, '-' ,_) r) when l.Depth < r.Depth => false,
        // (a +- b) + (c */ d) => ((c */ d) + a) +- b
        ((_, var p, _), '+', (_, var q, _)) when "+-".Contains(p) && "*/".Contains(q) => false,
        // a + (b + c) => (a + b) + c
        (var l, '+', (_, '+' ,_) r) => false,
        // a + (b - c) => (a + b) - c
        (var l, '+', (_, '-' ,_) r) => false,
        // a - (b + c) => (a - b) + c
        (_, '-', (_, '+', _)) => false,
        // a * (b * c) => (a * b) * c
        (var l, '*', (_, '*' ,_) r) => false,
        // a * (b / c) => (a * b) / c
        (var l, '*', (_, '/' ,_) r) => false,
        // a / (b / c) => (a * c) / b
        (var l, '/', (_, '/' ,_) r) => false,
        // a - (b - c) * d => (c - b) * d + a
        (_, '-', ((_, '-' ,_), '*', _)) => false,
        // a - (b - c) / d => (c - b) / d + a
        (_, '-', ((_, '-' ,_), '/', _)) => false,
        // a - (b - c) => a + c - b
        (_, '-', (_, '-', _)) => false,
        // (a - b) + c => (a + c) - b
        ((_, '-', var b), '+', var c) => false,

        (var l, _, var r) => l.HasPreferredTree() && r.HasPreferredTree()
    };

    static bool HasPreferredValues(this Expr expr) => expr switch {
        Const _ => true,

        // -a + b => b - a
        (var l, '+', var r) when l.Value < 0 && r.Value >= 0 => false,
        // b * a => a * b
        (var l, '*', var r) when l.Depth == r.Depth && l.Value > r.Value => false,
        // b + a => a + b
        (var l, '+', var r) when l.Depth == r.Depth && l.Value > r.Value => false,
        // (b o c) * (a o d) => (a o d) * (b o c)
        ((var a, _, _) l, '*', (var c, _, _) r) when l.Value == r.Value && l.Depth == r.Depth && a.Value < c.Value => false,
        // (b o c) + (a o d) => (a o d) + (b o c)
        ((var a, var p, _) l, '+', (var c, var q, _) r) when l.Value == r.Value && l.Depth == r.Depth && a.Value < c.Value => false,
        // (a * c) * b => (a * b) * c
        ((_, '*', var c), '*', var b) when b.Value < c.Value => false,
        // (a + c) + b => (a + b) + c
        ((_, '+', var c), '+', var b) when b.Value < c.Value => false,
        // (a - b) - c => (a - c) - b
        ((_, '-', var b), '-', var c) when b.Value < c.Value => false,
        // a / 1 => a * 1
        (_, '/', var b) when b.Value == 1 => false,
        // a * b / b => a + b - b
        ((_, '*', var b), '/', var c) when b.Value == c.Value => false,
        // a * 1 * 1 => a + 1 - 1
        ((_, '*', var b), '*', var c) when b.Value == 1 && c.Value == 1 => false,

        (var l, _, var r) => l.HasPreferredValues() && r.HasPreferredValues()
    };

    private struct Fraction : IEquatable<Fraction>, IComparable<Fraction>
    {
        public readonly int Numerator, Denominator;

        public Fraction(int numerator, int denominator)
            => (Numerator, Denominator) = (numerator, denominator) switch
        {
            (_, 0) => (Math.Sign(numerator), 0),
            (0, _) => (0, 1),
            (_, var d) when d < 0 => (-numerator, -denominator),
            _ => (numerator, denominator)
        };

        public static implicit operator Fraction(int i) => new Fraction(i, 1);
        public static Fraction operator +(Fraction a, Fraction b) =>
            new Fraction(a.Numerator * b.Denominator + a.Denominator * b.Numerator, a.Denominator * b.Denominator);
        public static Fraction operator -(Fraction a, Fraction b) =>
            new Fraction(a.Numerator * b.Denominator + a.Denominator * -b.Numerator, a.Denominator * b.Denominator);
        public static Fraction operator *(Fraction a, Fraction b) =>
            new Fraction(a.Numerator * b.Numerator, a.Denominator * b.Denominator);
        public static Fraction operator /(Fraction a, Fraction b) =>
            new Fraction(a.Numerator * b.Denominator, a.Denominator * b.Numerator);

        public static bool operator ==(Fraction a, Fraction b) => a.CompareTo(b) == 0;
        public static bool operator !=(Fraction a, Fraction b) => a.CompareTo(b) != 0;
        public static bool operator  <(Fraction a, Fraction b) => a.CompareTo(b)  < 0;
        public static bool operator  >(Fraction a, Fraction b) => a.CompareTo(b)  > 0;
        public static bool operator <=(Fraction a, Fraction b) => a.CompareTo(b) <= 0;
        public static bool operator >=(Fraction a, Fraction b) => a.CompareTo(b) >= 0;

        public bool Equals(Fraction other) => Numerator == other.Numerator && Denominator == other.Denominator;
        public override string ToString() => Denominator == 1 ? Numerator.ToString() : $"[{Numerator}/{Denominator}]";

        public int CompareTo(Fraction other) => (Numerator, Denominator, other.Numerator, other.Denominator) switch {
            var (    n1, d1,     n2, d2) when n1 == n2 && d1 == d2 => 0,
                (     0,  0,      _,  _) => (-1),
                (     _,  _,      0,  0) => 1,
            var (    n1, d1,     n2, d2) when d1 == d2 => n1.CompareTo(n2),
                (var n1,  0,      _,  _) => Math.Sign(n1),
                (     _,  _, var n2,  0) => Math.Sign(n2),
            var (    n1, d1,     n2, d2) => (n1 * d2).CompareTo(n2 * d1)
        };
    }

    private abstract class Expr
    {
        protected Expr(char symbol) => Symbol = symbol;
        public char Symbol { get; set; }
        public abstract Fraction Value { get; set; }
        public abstract int Depth { get; }
        public abstract void Deconstruct(out Expr left, out char symbol, out Expr right);
    }

    private sealed class Const : Expr
    {
        public Const(Fraction value) : base('c') => Value = value;
        public override Fraction Value { get; set; }
        public override int Depth => 0;
        public override void Deconstruct(out Expr left, out char symbol, out Expr right) => (left, symbol, right) = (this, Symbol, this);
        public override string ToString() => Value.ToString();
    }

    private sealed class Binary : Expr
    {
        public Binary(char symbol, Expr left, Expr right) : base(symbol) => (Left, Right) = (left, right);
        public Expr Left { get; }
        public Expr Right { get; }
        public override int Depth => Math.Max(Left.Depth, Right.Depth) + 1;
        public override void Deconstruct(out Expr left, out char symbol, out Expr right) => (left, symbol, right) = (Left, Symbol, Right);

        public override Fraction Value {
            get => Symbol switch {
                '*' => Left.Value * Right.Value,
                '/' => Left.Value / Right.Value,
                '+' => Left.Value + Right.Value,
                '-' => Left.Value - Right.Value,
                _ => throw new InvalidOperationException() };
            set {}
        }

        public override string ToString() => Symbol switch {
            '*' => ToString("+-".Contains(Left.Symbol), "+-".Contains(Right.Symbol)),
            '/' => ToString("+-".Contains(Left.Symbol), "*/+-".Contains(Right.Symbol)),
            '+' => ToString(false, false),
            '-' => ToString(false, "+-".Contains(Right.Symbol)),
            _ => $"[{Value}]"
        };

        private string ToString(bool wrapLeft, bool wrapRight) =>
            $"{(wrapLeft ? $"({Left})" : $"{Left}")} {Symbol} {(wrapRight ? $"({Right})" : $"{Right}")}";
    }
}
