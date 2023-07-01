using System;
using System.Collections.Generic;
using System.Linq;

public static class MultiCombinations
{
    private static void Main()
    {
        var set = new List<string> { "iced", "jam", "plain" };
        var combinations = GenerateCombinations(set, 2);

        foreach (var combination in combinations)
        {
            string combinationStr = string.Join(" ", combination);
            Console.WriteLine(combinationStr);
        }

        var donuts = Enumerable.Range(1, 10).ToList();

        int donutsCombinationsNumber = GenerateCombinations(donuts, 3).Count;

        Console.WriteLine("{0} ways to order 3 donuts given 10 types", donutsCombinationsNumber);
    }

    private static List<List<T>> GenerateCombinations<T>(List<T> combinationList, int k)
    {
        var combinations = new List<List<T>>();

        if (k == 0)
        {
            var emptyCombination = new List<T>();
            combinations.Add(emptyCombination);

            return combinations;
        }

        if (combinationList.Count == 0)
        {
            return combinations;
        }

        T head = combinationList[0];
        var copiedCombinationList = new List<T>(combinationList);

        List<List<T>> subcombinations = GenerateCombinations(copiedCombinationList, k - 1);

        foreach (var subcombination in subcombinations)
        {
            subcombination.Insert(0, head);
            combinations.Add(subcombination);
        }

        combinationList.RemoveAt(0);
        combinations.AddRange(GenerateCombinations(combinationList, k));

        return combinations;
    }
}
