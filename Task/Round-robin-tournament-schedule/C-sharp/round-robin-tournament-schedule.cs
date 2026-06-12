using System;
using System.Collections.Generic;
using System.Linq;

public class RoundRobinTournamentSchedule
{
    public static void Main(string[] args)
    {
        Console.WriteLine("Round robin for 12 players:");
        RoundRobin(12);
        Console.WriteLine("\n");
        Console.WriteLine("Round robin for 5 players, 0 denotes a bye:");
        RoundRobin(5);
    }

    private static void RoundRobin(int teamCount)
    {
        if (teamCount < 2)
        {
            throw new ArgumentException($"Number of teams must be greater than 2: {teamCount}");
        }

        List<int> rotatingList = Enumerable.Range(2, teamCount - 1).ToList();
        if (teamCount % 2 == 1)
        {
            rotatingList.Add(0);
            teamCount += 1;
        }

        for (int round = 1; round < teamCount; round++)
        {
            Console.Write($"Round {round,2}:");
            List<int> fixedList = new List<int> { 1 };
            fixedList.AddRange(rotatingList);
            for (int i = 0; i < teamCount / 2; i++)
            {
                Console.Write($" ( {fixedList[i],2} vs {fixedList[teamCount - 1 - i],2} )");
            }
            Console.WriteLine();
            Rotate(rotatingList, 1);
        }
    }

    private static void Rotate(List<int> list, int rotationCount)
    {
        int count = list.Count;
        if (count == 0) return;

        rotationCount %= count;
        if (rotationCount < 0)
        {
            rotationCount += count;
        }

        list.Reverse();
        list.Reverse(0, rotationCount);
        list.Reverse(rotationCount, count - rotationCount);
    }
}
