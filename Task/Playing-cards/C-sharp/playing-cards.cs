using System;
using System.Linq;
using System.Collections.Generic;

public struct Card
{
    public Card(string rank, string suit) : this()
    {
        Rank = rank;
        Suit = suit;
    }

    public string Rank { get; }
    public string Suit { get; }

    public override string ToString() => $"{Rank} of {Suit}";
}

public class Deck : IEnumerable<Card>
{
    static readonly string[] ranks = { "Two", "Three", "Four", "Five", "Six",
        "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King", "Ace" };
    static readonly string[] suits = { "Clubs", "Diamonds", "Hearts", "Spades" };
    readonly List<Card> cards;

    public Deck() {
        cards = (from suit in suits
                from rank in ranks
                select new Card(rank, suit)).ToList();
    }

    public int Count => cards.Count;

    public void Shuffle() {
        // using Knuth Shuffle (see at http://rosettacode.org/wiki/Knuth_shuffle)
        var random = new Random();
        for (int i = 0; i < cards.Count; i++) {
            int r = random.Next(i, cards.Count);
            var temp = cards[i];
            cards[i] = cards[r];
            cards[r] = temp;
        }
    }

    public Card Deal() {
        int last = cards.Count - 1;
        Card card = cards[last];
        //Removing from the front will shift the other items back 1 spot,
        //so that would be an O(n) operation. Removing from the back is O(1).
        cards.RemoveAt(last);
        return card;
    }

    public IEnumerator<Card> GetEnumerator() {
        //Reverse enumeration of the list so that they are returned in the order they would be dealt.
        //LINQ's Reverse() copies the entire list. Let's avoid that.
        for (int i = cards.Count - 1; i >= 0; i--)
            yield return cards[i];
    }

    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => GetEnumerator();
}
