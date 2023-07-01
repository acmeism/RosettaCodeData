using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using static System.Console;

public enum Colour { Red, Green, White, Yellow, Blue }
public enum Nationality { Englishman, Swede, Dane, Norwegian,German }
public enum Pet { Dog, Birds, Cats, Horse, Zebra }
public enum Drink { Coffee, Tea, Milk, Beer, Water }
public enum Smoke { PallMall, Dunhill, Blend, BlueMaster, Prince}

public static class ZebraPuzzle
{
    private static (Colour[] colours, Drink[] drinks, Smoke[] smokes, Pet[] pets, Nationality[] nations) _solved;

    static ZebraPuzzle()
    {
        var solve = from colours in Permute<Colour>()  //r1 5 range
                    where (colours,Colour.White).IsRightOf(colours, Colour.Green) // r5
                    from nations in Permute<Nationality>()
                    where nations[0] == Nationality.Norwegian // r10
                    where (nations, Nationality.Englishman).IsSameIndex(colours, Colour.Red) //r2
                    where (nations,Nationality.Norwegian).IsNextTo(colours,Colour.Blue) // r15
                    from drinks in Permute<Drink>()
                    where drinks[2] == Drink.Milk //r9
                    where (drinks, Drink.Coffee).IsSameIndex(colours, Colour.Green) // r6
                    where (drinks, Drink.Tea).IsSameIndex(nations, Nationality.Dane) //r4
                    from pets in Permute<Pet>()
                    where (pets, Pet.Dog).IsSameIndex(nations, Nationality.Swede) // r3
                    from smokes in Permute<Smoke>()
                    where (smokes, Smoke.PallMall).IsSameIndex(pets, Pet.Birds) // r7
                    where (smokes, Smoke.Dunhill).IsSameIndex(colours, Colour.Yellow) // r8
                    where (smokes, Smoke.Blend).IsNextTo(pets, Pet.Cats) // r11
                    where (smokes, Smoke.Dunhill).IsNextTo(pets, Pet.Horse) //r12
                    where (smokes, Smoke.BlueMaster).IsSameIndex(drinks, Drink.Beer) //r13
                    where (smokes, Smoke.Prince).IsSameIndex(nations, Nationality.German) // r14
                    where (drinks,Drink.Water).IsNextTo(smokes,Smoke.Blend) // r16
                    select (colours, drinks, smokes, pets, nations);

        _solved = solve.First();
    }

    private static int IndexOf<T>(this T[] arr, T obj) => Array.IndexOf(arr, obj);

    private static bool IsRightOf<T, U>(this (T[] a, T v) right, U[] a, U v) => right.a.IndexOf(right.v) == a.IndexOf(v) + 1;

    private static bool IsSameIndex<T, U>(this (T[] a, T v)x, U[] a, U v) => x.a.IndexOf(x.v) == a.IndexOf(v);

    private static bool IsNextTo<T, U>(this (T[] a, T v)x, U[] a,  U v) => (x.a,x.v).IsRightOf(a, v) || (a,v).IsRightOf(x.a,x.v);

    // made more generic from https://codereview.stackexchange.com/questions/91808/permutations-in-c
    public static IEnumerable<IEnumerable<T>> Permutations<T>(this IEnumerable<T> values)
    {
        if (values.Count() == 1)
            return values.ToSingleton();

        return values.SelectMany(v => Permutations(values.Except(v.ToSingleton())),(v, p) => p.Prepend(v));
    }

    public static IEnumerable<T[]> Permute<T>() => ToEnumerable<T>().Permutations().Select(p=>p.ToArray());

    private static IEnumerable<T> ToSingleton<T>(this T item){ yield return item; }

    private static IEnumerable<T> ToEnumerable<T>() => Enum.GetValues(typeof(T)).Cast<T>();

    public static new String ToString()
    {
        var sb = new StringBuilder();
        sb.AppendLine("House Colour Drink    Nationality Smokes     Pet");
        sb.AppendLine("───── ────── ──────── ─────────── ────────── ─────");
        var (colours, drinks, smokes, pets, nations) = _solved;
        for (var i = 0; i < 5; i++)
            sb.AppendLine($"{i+1,5} {colours[i],-6} {drinks[i],-8} {nations[i],-11} {smokes[i],-10} {pets[i],-10}");
        return sb.ToString();
    }

    public static void Main(string[] arguments)
    {
        var owner = _solved.nations[_solved.pets.IndexOf(Pet.Zebra)];
        WriteLine($"The zebra owner is {owner}");
        Write(ToString());
        Read();
    }
}
