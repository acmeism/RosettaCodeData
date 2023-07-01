using System;
using System.Collections.Generic;
using System.Text;

namespace FreeCellDeals
{
    public class RNG
    {
        private int _state;

        public RNG()
        {
            _state = (int)DateTime.Now.Ticks;
        }

        public RNG(int n)
        {
            _state = n;
        }
        public int Next()
        {
            return ((_state = 214013 * _state + 2531011) & int.MaxValue) >> 16;
        }
    }

    public enum Rank
    {
        Ace,
        One,
        Two,
        Three,
        Four,
        Five,
        Six,
        Seven,
        Eight,
        Nine,
        Ten,
        Jack,
        Queen,
        King
    }

    public enum Suit
    {
        Clubs,
        Diamonds,
        Hearts,
        Spades
    }

    public class Card
    {
        private const string Ranks = "A23456789TJQK";
        private const string Suits = "CDHS";

        private Rank _rank;
        public Rank Rank
        {
            get
            {
                return _rank;
            }
            set
            {
                if ((int)value < 0 || (int)value > 12)
                {
                    throw new InvalidOperationException("Setting card rank out of range");
                }
                _rank = value;
            }
        }

        private Suit _suit;
        public Suit Suit
        {
            get
            {
                return _suit;
            }
            set
            {
                if ((int)value < 0 || (int)value > 3)
                {
                    throw new InvalidOperationException("Setting card rank out of range");
                }
                _suit = value;
            }
        }

        public Card(Rank rank, Suit suit)
        {
            Rank = rank;
            Suit = suit;
        }

        public int NRank()
        {
            return (int) Rank;
        }

        public int NSuit()
        {
            return (int) Suit;
        }

        public override string ToString()
        {
            return new string(new[] {Ranks[NRank()], Suits[NSuit()]});
        }
    }

    public class FreeCellDeal
    {
        public List<Card> Deck { get; private set; }

        public FreeCellDeal(int iDeal)
        {
            RNG rng = new RNG(iDeal);

            List<Card> rDeck = new List<Card>();
            Deck = new List<Card>();

            for (int rank = 0; rank < 13; rank++)
            {
                for (int suit = 0; suit < 4; suit++)
                {
                    rDeck.Add(new Card((Rank)rank, (Suit)suit));
                }
            }

            // Normally we deal from the front of a deck.  The algorithm "deals" from the back so we reverse the
            // deck here to more conventionally deal from the front/start of the array.
            for (int iCard = 51; iCard >= 0; iCard--)
            {
                int iSwap = rng.Next() % (iCard + 1);
                Deck.Add(rDeck[iSwap]);
                rDeck[iSwap] = rDeck[iCard];
            }
        }

        public override string ToString()
        {
            StringBuilder sb = new StringBuilder();
            for (int iRow = 0; iRow < 6; iRow++ )
            {
                for (int iCol = 0; iCol < 8; iCol++)
                {
                    sb.AppendFormat("{0} ", Deck[iRow * 8 + iCol]);
                }
                sb.Append("\n");
            }
            for (int iCard = 48; iCard < 52; iCard++)
            {
                sb.AppendFormat("{0} ", Deck[iCard]);
            }
            return sb.ToString();
        }
    }

    class Program
    {
        static void Main()
        {
            Console.WriteLine(new FreeCellDeal(1));
            Console.WriteLine();
            Console.WriteLine(new FreeCellDeal(617));
        }
    }
}
