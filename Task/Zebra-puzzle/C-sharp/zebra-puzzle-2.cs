using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using static System.Console;

namespace ZebraPuzzleSolver
{
    public enum Colour { Red, Green, White, Yellow, Blue }
    public enum Nationality { Englishman, Swede, Dane, Norwegian, German }
    public enum Pet { Dog, Birds, Cats, Horse, Zebra }
    public enum Drink { Coffee, Tea, Milk, Beer, Water }
    public enum Smoke { PallMall, Dunhill, Blend, BlueMaster, Prince }

    public struct House
    {
        public Drink D { get; }
        public Colour C { get; }
        public Pet P { get; }
        public Nationality N { get; }
        public Smoke S { get; }

        House(Drink d, Colour c, Pet p, Nationality n, Smoke s) => (D, C, P, N, S) = (d, c, p, n, s);

        public static House Create(Drink d, Colour c, Pet p, Nationality n, Smoke s) => new House(d, c, p, n, s);

        public bool AllUnequal(House other) => D != other.D && C != other.C && P != other.P && N != other.N && S != other.S;

        public override string ToString() =>$"{C,-6} {D,-8} {N,-11} {S,-10} {P,-10}";
    }

    public static class LinqNoPerm
    {
        public static IEnumerable<T> ToEnumerable<T>() => Enum.GetValues(typeof(T)).Cast<T>();

        public static IEnumerable<House> FreeCandidates(this IEnumerable<House> houses, IEnumerable<House> picked) =>
            houses.Where(house => picked.All(house.AllUnequal));

       static Dictionary<Type, Func<House, dynamic, bool>> _eFn = new Dictionary<Type, Func<House, dynamic, bool>>
            { {typeof(Drink),(h,e)=>h.D==e},
              {typeof(Nationality),(h,e)=>h.N==e},
              {typeof(Colour),(h,e)=>h.C==e},
              {typeof(Pet),(h,e)=>h.P==e},
              {typeof(Smoke),(h, e)=>h.S==e}
            };

        public static bool IsNextTo<T, U>(this IEnumerable<House> hs,T t, U u) => hs.IsLeftOf(t,u) || hs.IsLeftOf(u, t);

        public static bool IsLeftOf<T, U>(this IEnumerable<House> hs, T left, U right) =>
            hs.Zip(hs.Skip(1), (l, r) => (_eFn[left.GetType()](l, left) && _eFn[right.GetType()](r, right))).Any(l => l);

        static House[] _solved;

        static LinqNoPerm()
        {
            var candidates =
                from colours in ToEnumerable<Colour>()
                from nations in ToEnumerable<Nationality>()
                from drinks in ToEnumerable<Drink>()
                from pets in ToEnumerable<Pet>()
                from smokes in ToEnumerable<Smoke>()
                where (colours == Colour.Red) == (nations == Nationality.Englishman) //r2
                where (nations == Nationality.Swede) == (pets == Pet.Dog) //r3
                where (nations == Nationality.Dane) == (drinks == Drink.Tea) //r4
                where (colours == Colour.Green) == (drinks == Drink.Coffee) //r6
                where (smokes == Smoke.PallMall) == (pets == Pet.Birds) //r7
                where (smokes == Smoke.Dunhill) == (colours == Colour.Yellow) // r8
                where (smokes == Smoke.BlueMaster) == (drinks == Drink.Beer) //r13
                where (smokes == Smoke.Prince) == (nations == Nationality.German) // r14
                select House.Create(drinks,colours,pets,nations, smokes);
            var members =
                from h1 in candidates
                where h1.N == Nationality.Norwegian //r10
                from h3 in candidates.FreeCandidates(new[] { h1 })
                where h3.D == Drink.Milk //r9
                from h2 in candidates.FreeCandidates(new[] { h1, h3 })
                let h123 = new[] { h1, h2, h3 }
                where h123.IsNextTo(Nationality.Norwegian, Colour.Blue) //r15
                where h123.IsNextTo(Smoke.Blend, Pet.Cats)//r11
                where h123.IsNextTo(Smoke.Dunhill, Pet.Horse) //r12
                from h4 in candidates.FreeCandidates(h123)
                from h5 in candidates.FreeCandidates(new[] { h1, h3, h2, h4 })
                let houses = new[] { h1, h2, h3, h4, h5 }
                where houses.IsLeftOf(Colour.Green, Colour.White) //r5
                select houses;
            _solved = members.First();
        }

        public static new String ToString()
        {
            var sb = new StringBuilder();

            sb.AppendLine("House Colour Drink    Nationality Smokes     Pet");
            sb.AppendLine("───── ────── ──────── ─────────── ────────── ─────");
            for (var i = 0; i < 5; i++)
                sb.AppendLine($"{i + 1,5} {_solved[i].ToString()}");
            return sb.ToString();
        }

        public static void Main(string[] arguments)
        {
            var owner = _solved.Where(h=>h.P==Pet.Zebra).Single().N;
            WriteLine($"The zebra owner is {owner}");
            Write(ToString());
            Read();
        }
    }
}
