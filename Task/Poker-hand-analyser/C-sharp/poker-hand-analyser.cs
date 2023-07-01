using System;
using System.Collections.Generic;
using static System.Linq.Enumerable;

public static class PokerHandAnalyzer
{
    private enum Hand {
        Invalid, High_Card, One_Pair, Two_Pair, Three_Of_A_Kind, Straight,
        Flush, Full_House, Four_Of_A_Kind, Straight_Flush, Five_Of_A_Kind
    }

    private const bool Y = true;
    private const char C = '♣', D = '♦', H = '♥', S = '♠';
    private const int rankMask = 0b11_1111_1111_1111;
    private const int suitMask = 0b1111 << 14;
    private static readonly string[] ranks = { "a", "2", "3", "4", "5", "6", "7", "8", "9", "10", "j", "q", "k" };
    private static readonly string[] suits = { C + "", D + "", H + "", S + "" };
    private static readonly Card[] deck = (from suit in Range(1, 4) from rank in Range(1, 13) select new Card(rank, suit)).ToArray();

    public static void Main() {
        string[] hands = {
            "2♥ 2♦ 2♣ k♣ q♦",
            "2♥ 5♥ 7♦ 8♣ 9♠",
            "a♥ 2♦ 3♣ 4♣ 5♦",
            "2♥ 3♥ 2♦ 3♣ 3♦",
            "2♥ 7♥ 2♦ 3♣ 3♦",
            "2♥ 7♥ 7♦ 7♣ 7♠",
            "10♥ j♥ q♥ k♥ a♥",
            "4♥ 4♠ k♠ 5♦ 10♠",
            "q♣ 10♣ 7♣ 6♣ 4♣",
            "4♥ 4♣ 4♥ 4♠ 4♦", //duplicate card
            "joker 2♦ 2♠ k♠ q♦",
            "joker 5♥ 7♦ 8♠ 9♦",
            "joker 2♦ 3♠ 4♠ 5♠",
            "joker 3♥ 2♦ 3♠ 3♦",
            "joker 7♥ 2♦ 3♠ 3♦",
            "joker 7♥ 7♦ 7♠ 7♣",
            "joker j♥ q♥ k♥ A♥",
            "joker 4♣ k♣ 5♦ 10♠",
            "joker k♣ 7♣ 6♣ 4♣",
            "joker 2♦ joker 4♠ 5♠",
            "joker Q♦ joker A♠ 10♠",
            "joker Q♦ joker A♦ 10♦",
            "joker 2♦ 2♠ joker q♦"
        };
        foreach (var h in hands) {
            Console.WriteLine($"{h}: {Analyze(h).Name()}");
        }
    }

    static string Name(this Hand hand) => string.Join('-', hand.ToString().Split('_')).ToLower();

    static List<T> With<T>(this List<T> list, int index, T item) {
        list[index] = item;
        return list;
    }

    struct Card : IEquatable<Card>, IComparable<Card>
    {
        public static readonly Card Invalid = new Card(-1, -1);
        public static readonly Card Joker = new Card(0, 0);

        public Card(int rank, int suit) {
            (Rank, Suit, Code) = (rank, suit) switch {
                (_, -1) => (-1, -1, -1),
                (-1, _) => (-1, -1, -1),
                (0, _) => (0, 0, 0),
                (1, _) => (rank, suit, (1 << (13 + suit)) | ((1 << 13) | 1)),
                (_, _) => (rank, suit, (1 << (13 + suit)) | (1 << (rank - 1)))
            };
        }

        public static implicit operator Card((int rank, int suit) tuple) => new Card(tuple.rank, tuple.suit);
        public int Rank { get; }
        public int Suit { get; }
        public int Code { get; }

        public override string ToString() => Rank switch {
            -1 => "invalid",
            0 => "joker",
            _ => $"{ranks[Rank-1]}{suits[Suit-1]}"
        };

        public override int GetHashCode() => Rank << 16 | Suit;
        public bool Equals(Card other) => Rank == other.Rank && Suit == other.Suit;

        public int CompareTo(Card other) {
            int c = Rank.CompareTo(other.Rank);
            if (c != 0) return c;
            return Suit.CompareTo(other.Suit);
        }
    }

    static Hand Analyze(string hand) {
        var cards = ParseHand(hand);
        if (cards.Count != 5) return Hand.Invalid; //hand must consist of 5 cards
        cards.Sort();
        if (cards[0].Equals(Card.Invalid)) return Hand.Invalid;
        int jokers = cards.LastIndexOf(Card.Joker) + 1;
        if (jokers > 2) return Hand.Invalid; //more than 2 jokers
        if (cards.Skip(jokers).Distinct().Count() + jokers != 5) return Hand.Invalid; //duplicate cards

        if (jokers == 2) return (from c0 in deck from c1 in deck select Evaluate(cards.With(0, c0).With(1, c1))).Max();
        if (jokers == 1) return (from c0 in deck select Evaluate(cards.With(0, c0))).Max();
        return Evaluate(cards);
    }

    static List<Card> ParseHand(string hand) =>
        hand.Split(default(char[]), StringSplitOptions.RemoveEmptyEntries)
        .Select(card => ParseCard(card.ToLower())).ToList();

    static Card ParseCard(string card) => (card.Length, card) switch {
        (5, "joker") => Card.Joker,
        (3, _) when card[..2] == "10" => (10, ParseSuit(card[2])),
        (2, _) => (ParseRank(card[0]), ParseSuit(card[1])),
        (_, _) => Card.Invalid
    };

    static int ParseRank(char rank) => rank switch {
        'a' => 1,
        'j' => 11,
        'q' => 12,
        'k' => 13,
        _ when rank >= '2' && rank <= '9' => rank - '0',
        _ => -1
    };

    static int ParseSuit(char suit) => suit switch {
        C => 1, 'c' => 1,
        D => 2, 'd' => 2,
        H => 3, 'h' => 3,
        S => 4, 's' => 4,
        _ => -1
    };

    static Hand Evaluate(List<Card> hand) {
        var frequencies = hand.GroupBy(c => c.Rank).Select(g => g.Count()).OrderByDescending(c => c).ToArray();
        (int f0, int f1) = (frequencies[0], frequencies.Length > 1 ? frequencies[1] : 0);

        return (IsFlush(), IsStraight(), f0, f1) switch {
            (_, _, 5, _) => Hand.Five_Of_A_Kind,
            (Y, Y, _, _) => Hand.Straight_Flush,
            (_, _, 4, _) => Hand.Four_Of_A_Kind,
            (_, _, 3, 2) => Hand.Full_House,
            (Y, _, _, _) => Hand.Flush,
            (_, Y, _, _) => Hand.Straight,
            (_, _, 3, _) => Hand.Three_Of_A_Kind,
            (_, _, 2, 2) => Hand.Two_Pair,
            (_, _, 2, _) => Hand.One_Pair,
                        _ => Hand.High_Card
        };

        bool IsFlush() => hand.Aggregate(suitMask, (r, c) => r & c.Code) > 0;

        bool IsStraight() {
            int r = hand.Aggregate(0, (r, c) => r | c.Code) & rankMask;
            for (int i = 0; i < 4; i++) r &= r << 1;
            return r > 0;
        }
    }

}
