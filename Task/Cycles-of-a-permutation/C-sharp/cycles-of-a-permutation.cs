using System;
using System.Collections.Generic;
using System.Linq;

public class CyclesOfAPermutation
{
    public enum Day
    {
        MONDAY,
        TUESDAY,
        WEDNESDAY,
        THURSDAY,
        FRIDAY,
        SATURDAY,
        SUNDAY
    }

    private static readonly Dictionary<Day, string> DayLetters = new Dictionary<Day, string>
    {
        { Day.MONDAY, "HANDYCOILSERUPT" },
        { Day.TUESDAY, "SPOILUNDERYACHT" },
        { Day.WEDNESDAY, "DRAINSTYLEPOUCH" },
        { Day.THURSDAY, "DITCHSYRUPALONE" },
        { Day.FRIDAY, "SOAPYTHIRDUNCLE" },
        { Day.SATURDAY, "SHINEPARTYCLOUD" },
        { Day.SUNDAY, "RADIOLUNCHTYPES" }
    };

    private static readonly Day[] DaysInOrder =
    {
        Day.MONDAY, Day.TUESDAY, Day.WEDNESDAY, Day.THURSDAY,
        Day.FRIDAY, Day.SATURDAY, Day.SUNDAY
    };

    public static Day Previous(Day day)
    {
        int index = Array.IndexOf(DaysInOrder, day);
        return index == 0 ? Day.SUNDAY : DaysInOrder[index - 1];
    }

    public static string Letters(Day day)
    {
        return DayLetters[day];
    }

    public static void Main(string[] args)
    {
        var permutation = new Permutation(Letters(Day.MONDAY).Length);

        Console.WriteLine("On Thursdays Alf and Betty should rearrange their letters using these cycles:");
        var oneLineWedThu = permutation.CreateOneLine(Letters(Day.WEDNESDAY), Letters(Day.THURSDAY));
        var cyclesWedThu = permutation.OneLineToCycles(oneLineWedThu);
        Console.WriteLine(FormatCycles(cyclesWedThu));
        Console.WriteLine($"So that {Letters(Day.WEDNESDAY)} becomes {Letters(Day.THURSDAY)}");

        Console.WriteLine("\nOr they could use the one line notation:");
        Console.WriteLine(FormatList(oneLineWedThu));

        Console.WriteLine("\nTo revert to the Wednesday arrangement they should use these cycles:");
        var cyclesThuWed = permutation.CyclesInverse(cyclesWedThu);
        Console.WriteLine(FormatCycles(cyclesThuWed));

        Console.WriteLine("\nOr with the one line notation:");
        var oneLineThuWed = permutation.OneLineInverse(oneLineWedThu);
        Console.WriteLine(FormatList(oneLineThuWed));
        Console.WriteLine($"So that {Letters(Day.THURSDAY)} becomes " +
                         permutation.OneLinePermuteString(Letters(Day.THURSDAY), oneLineThuWed));

        Console.WriteLine("\nStarting with the Sunday arrangement and applying each of the daily");
        Console.WriteLine("arrangements consecutively, the arrangements will be:");
        Console.WriteLine($"\n      {Letters(Day.SUNDAY)}\n");

        foreach (Day day in DaysInOrder)
        {
            var dayOneLine = permutation.CreateOneLine(Letters(Previous(day)), Letters(day));
            string result = permutation.OneLinePermuteString(Letters(Previous(day)), dayOneLine);
            string ending = day == Day.SATURDAY ? "\n" : "";
            Console.WriteLine($"{day,11}: {result}{ending}");
        }

        Console.WriteLine("\nTo go from Wednesday to Friday in a single step they should use these cycles:");
        var oneLineThuFri = permutation.CreateOneLine(Letters(Day.THURSDAY), Letters(Day.FRIDAY));
        var cyclesThuFri = permutation.OneLineToCycles(oneLineThuFri);
        var cyclesWedFri = permutation.CombinedCycles(cyclesWedThu, cyclesThuFri);
        Console.WriteLine(FormatCycles(cyclesWedFri));
        Console.WriteLine($"So that {Letters(Day.WEDNESDAY)} becomes " +
                         permutation.CyclesPermuteString(Letters(Day.WEDNESDAY), cyclesWedFri));

        Console.WriteLine("\nThese are the signatures of the permutations:\n");
        foreach (Day day in DaysInOrder)
        {
            var oneLine = permutation.CreateOneLine(Letters(Previous(day)), Letters(day));
            Console.WriteLine($"{day,11}: {permutation.Signature(oneLine)}");
        }

        Console.WriteLine("\nThese are the orders of the permutations:\n");
        foreach (Day day in DaysInOrder)
        {
            var oneLine = permutation.CreateOneLine(Letters(Previous(day)), Letters(day));
            Console.WriteLine($"{day,11}: {permutation.Order(oneLine)}");
        }

        Console.WriteLine("\nApplying the Friday cycle to a string 10 times:");
        string word = "STOREDAILYPUNCH";
        Console.WriteLine($"\n 0 {word}\n");
        for (int i = 1; i <= 10; i++)
        {
            word = permutation.CyclesPermuteString(word, cyclesThuFri);
            string ending = i == 9 ? "\n" : "";
            Console.WriteLine($"{i,2} {word}{ending}");
        }
    }

    private static string FormatCycles(List<List<int>> cycles)
    {
        if (cycles.Count == 0) return "[]";
        return "[" + string.Join(", ", cycles.Select(FormatList)) + "]";
    }

    private static string FormatList(List<int> list)
    {
        return "[" + string.Join(", ", list) + "]";
    }
}

public class Permutation
{
    private readonly int lettersCount;

    // Initialize the length of the strings to be permuted.
    public Permutation(int lettersCount)
    {
        this.lettersCount = lettersCount;
    }

    // Return the permutation in one line form that transforms the string 'source' into the string 'destination'.
    public List<int> CreateOneLine(string source, string destination)
    {
        var result = new List<int>();
        foreach (char ch in destination)
        {
            result.Add(source.IndexOf(ch) + 1);
        }

        while (result.Count > 0 && result.Last() == result.Count)
        {
            result.RemoveAt(result.Count - 1);
        }

        return result;
    }

    // Return the cycles of the permutation given in one line form.
    public List<List<int>> OneLineToCycles(List<int> oneLine)
    {
        var cycles = new List<List<int>>();
        var used = new HashSet<int>();

        for (int number = 1; used.Count < oneLine.Count; number++)
        {
            if (!used.Contains(number))
            {
                int index = oneLine.IndexOf(number) + 1;

                if (index > 0)
                {
                    var cycle = new List<int> { number };

                    while (number != index)
                    {
                        cycle.Add(index);
                        index = oneLine.IndexOf(index) + 1;
                    }

                    if (cycle.Count > 1)
                    {
                        cycles.Add(cycle);
                    }
                    used.UnionWith(cycle);
                }
            }
        }

        return cycles;
    }

    // Return the one line notation of the permutation given in cycle form.
    public List<int> CyclesToOneLine(List<List<int>> cycles)
    {
        var oneLine = Enumerable.Range(1, lettersCount).ToList();
        for (int number = 1; number <= lettersCount; number++)
        {
            foreach (var cycle in cycles)
            {
                int index = cycle.IndexOf(number);
                if (index >= 0)
                {
                    oneLine[number - 1] = cycle[(index - 1 + cycle.Count) % cycle.Count];
                    break;
                }
            }
        }

        return oneLine;
    }

    // Return the inverse of the given permutation in cycle form.
    public List<List<int>> CyclesInverse(List<List<int>> cycles)
    {
        var cyclesInverse = cycles.Select(list => new List<int>(list)).ToList();

        foreach (var cycle in cyclesInverse)
        {
            var first = cycle[0];
            cycle.RemoveAt(0);
            cycle.Add(first);
            cycle.Reverse();
        }

        return cyclesInverse;
    }

    // Return the inverse of the given permutation in one line notation.
    public List<int> OneLineInverse(List<int> oneLine)
    {
        var oneLineInverse = new List<int>(new int[oneLine.Count]);
        for (int number = 1; number <= oneLine.Count; number++)
        {
            oneLineInverse[number - 1] = oneLine.IndexOf(number) + 1;
        }

        return oneLineInverse;
    }

    // Return the cycles obtained by composing cycleOne first followed by cycleTwo.
    public List<List<int>> CombinedCycles(List<List<int>> cyclesOne, List<List<int>> cyclesTwo)
    {
        var combinedCycles = new List<List<int>>();
        var used = new HashSet<int>();

        for (int number = 1; used.Count < lettersCount; number++)
        {
            if (!used.Contains(number))
            {
                int combined = Next(Next(number, cyclesOne), cyclesTwo);
                var cycle = new List<int> { number };

                while (number != combined)
                {
                    cycle.Add(combined);
                    combined = Next(Next(combined, cyclesOne), cyclesTwo);
                }

                if (cycle.Count > 1)
                {
                    combinedCycles.Add(cycle);
                }
                used.UnionWith(cycle);
            }
        }

        return combinedCycles;
    }

    // Return the given string permuted by the permutation given in one line form.
    public string OneLinePermuteString(string text, List<int> oneLine)
    {
        var permuted = new List<string>();

        foreach (int index in oneLine)
        {
            permuted.Add(text.Substring(index - 1, 1));
        }
        permuted.Add(text.Substring(permuted.Count));

        return string.Join("", permuted);
    }

    // Return the given string permuted by the permutation given in cycle form.
    public string CyclesPermuteString(string text, List<List<int>> cycles)
    {
        var permuted = text.ToCharArray().Select(c => c.ToString()).ToList();

        foreach (var cycle in cycles)
        {
            foreach (int number in cycle)
            {
                permuted[Next(number, cycles) - 1] = text.Substring(number - 1, 1);
            }
        }

        return string.Join("", permuted);
    }

    // Return the signature of the permutation given in one line form.
    public string Signature(List<int> oneLine)
    {
        var cycles = OneLineToCycles(oneLine);
        long evenCount = cycles.Count(list => list.Count % 2 == 0);
        return evenCount % 2 == 0 ? "+1" : "-1";
    }

    // Return the order of the permutation given in one line form.
    public int Order(List<int> oneLine)
    {
        var cycles = OneLineToCycles(oneLine);
        var sizes = cycles.Select(list => list.Count).ToList();
        return sizes.Aggregate(1, (one, two) => one * (two / Gcd(one, two)));
    }

    // Return the element to which the given number is mapped by the permutation given in cycle form.
    private int Next(int number, List<List<int>> cycles)
    {
        foreach (var cycle in cycles)
        {
            if (cycle.Contains(number))
            {
                return cycle[(cycle.IndexOf(number) + 1) % cycle.Count];
            }
        }

        return number;
    }

    // Return the greatest common divisor of the two given numbers.
    private int Gcd(int one, int two)
    {
        return two == 0 ? one : Gcd(two, one % two);
    }
}
