using System;
using System.Collections.Generic;
using System.Linq;

public class MindBogglingCardTrick
{
    public static void Main(string[] args)
    {
        List<char> cards = new List<char>();
        cards.AddRange(Enumerable.Repeat('R', 26));
        cards.AddRange(Enumerable.Repeat('B', 26));
        Shuffle(cards);

        List<char> redPile = new List<char>();
        List<char> blackPile = new List<char>();
        List<char> discardPile = new List<char>();

        for (int i = 0; i < 52; i += 2)
        {
            if (cards[i] == 'R')
            {
                redPile.Add(cards[i + 1]);
            }
            else
            {
                blackPile.Add(cards[i + 1]);
            }
            discardPile.Add(cards[i]);
        }

        Console.WriteLine("A sample run.\n");
        Console.WriteLine("After dealing the cards the state of the piles is:");
        Console.WriteLine($"    Red    : {redPile.Count} cards -> {string.Join(",", redPile)}");
        Console.WriteLine($"    Black  : {blackPile.Count} cards -> {string.Join(",", blackPile)}");
        Console.WriteLine($"    Discard: {discardPile.Count} cards -> {string.Join(",", discardPile)}");

        Random random = new Random();
        int minimumSize = Math.Min(redPile.Count, blackPile.Count);
        int choice = random.Next(1, minimumSize + 1);

        List<int> redIndexes = Enumerable.Range(0, redPile.Count).ToList();
        List<int> blackIndexes = Enumerable.Range(0, blackPile.Count).ToList();
        Shuffle(redIndexes);
        Shuffle(blackIndexes);
        List<int> redChosenIndexes = redIndexes.Take(choice).ToList();
        List<int> blackChosenIndexes = blackIndexes.Take(choice).ToList();

        Console.WriteLine($"\nNumber of cards are to be swapped: {choice}");
        Console.WriteLine("The respective zero-based indices of the cards to be swapped are:");
        Console.WriteLine($"    Red  : {string.Join(", ", redChosenIndexes)}");
        Console.WriteLine($"    Black: {string.Join(", ", blackChosenIndexes)}");

        for (int i = 0; i < choice; i++)
        {
            char temp = redPile[redChosenIndexes[i]];
            redPile[redChosenIndexes[i]] = blackPile[blackChosenIndexes[i]];
            blackPile[blackChosenIndexes[i]] = temp;
        }

        Console.WriteLine($"\nAfter swapping cards the state of the red and black piles is:");
        Console.WriteLine($"    Red  : {string.Join(", ", redPile)}");
        Console.WriteLine($"    Black: {string.Join(", ", blackPile)}");

        int redCount = redPile.Count(ch => ch == 'R');
        int blackCount = blackPile.Count(ch => ch == 'B');

        Console.WriteLine($"\nThe number of red cards in the red pile: {redCount}");
        Console.WriteLine($"The number of black cards in the black pile: {blackCount}");
        if (redCount == blackCount)
        {
            Console.WriteLine("So the assertion is correct.");
        }
        else
        {
            Console.WriteLine("So the assertion is incorrect.");
        }
    }

    private static void Shuffle<T>(List<T> list)
    {
        Random rng = new Random();
        int n = list.Count;
        while (n > 1)
        {
            n--;
            int k = rng.Next(n + 1);
            T value = list[k];
            list[k] = list[n];
            list[n] = value;
        }
    }
}
