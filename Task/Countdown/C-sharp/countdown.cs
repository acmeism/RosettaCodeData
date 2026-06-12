using System;
using System.Collections.Generic;
using System.Linq;

public sealed class Countdown
{
    public static void Main(string[] args)
    {
        List<int> allNumbers = new List<int>
        {
            1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100
        };

        Random random = new Random();
        allNumbers = allNumbers.OrderBy(x => random.Next()).ToList();

        List<List<int>> numberLists = new List<List<int>>
        {
            new List<int> { 3, 6, 25, 50, 75, 100 },
            new List<int> { 100, 75, 50, 25, 6, 3 },
            new List<int> { 8, 4, 4, 6, 8, 9 },
            allNumbers.Take(6).ToList()
        };

        List<int> targetList = new List<int> { 952, 952, 594, random.Next(101, 1000) };

        for (int i = 0; i < targetList.Count; i++)
        {
            Console.WriteLine($"Using : [{string.Join(", ", numberLists[i])}]");
            Console.WriteLine($"Target: {targetList[i]}");
            bool done = CountdownSolver(numberLists[i], targetList[i]);
            if (!done)
            {
                Console.WriteLine("No solution found");
            }
            Console.WriteLine();
        }
    }

    private static bool CountdownSolver(List<int> numbers, int target)
    {
        if (numbers.Count <= 1)
        {
            return false;
        }

        foreach (int n0 in numbers)
        {
            List<int> numbers1 = new List<int>(numbers);
            numbers1.Remove(n0);

            foreach (int n1 in numbers1)
            {
                List<int> numbers2 = new List<int>(numbers1);
                numbers2.Remove(n1);

                if (n1 >= n0)
                {
                    int result = n1 + n0;
                    List<int> numbersNext = new List<int>(numbers2) { result };
                    if (result == target || CountdownSolver(numbersNext, target))
                    {
                        Console.WriteLine($"{result} = {n1} + {n0}");
                        return true;
                    }

                    if (n0 != 1)
                    {
                        result = n1 * n0;
                        numbersNext = new List<int>(numbers2) { result };
                        if (result == target || CountdownSolver(numbersNext, target))
                        {
                            Console.WriteLine($"{result} = {n1} * {n0}");
                            return true;
                        }
                    }

                    if (n1 != n0)
                    {
                        result = n1 - n0;
                        numbersNext = new List<int>(numbers2) { result };
                        if (result == target || CountdownSolver(numbersNext, target))
                        {
                            Console.WriteLine($"{result} = {n1} - {n0}");
                            return true;
                        }
                    }

                    if (n0 != 1 && n1 % n0 == 0)
                    {
                        result = n1 / n0;
                        numbersNext = new List<int>(numbers2) { result };
                        if (result == target || CountdownSolver(numbersNext, target))
                        {
                            Console.WriteLine($"{result} = {n1} / {n0}");
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }
}
