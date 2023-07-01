using System;
using System.Text;

namespace FreeCellConsole
{
	public class Rand {
		long _seed;
		public Rand(int seed=1) {
			_seed = seed;
		}
		public int Next() {
			return (int) ((_seed = (_seed * 214013 + 2531011) & int.MaxValue) >> 16);
		}
	}
	
	public class Card {
		private static readonly string kSuits = "♣♦♥♠";
		private static readonly string kValues = "A23456789TJQK";
		public int Value { get; set; }
		public int Suit { get; set; }
		public Card(int rawvalue=0) : this(rawvalue / 4, rawvalue % 4) {
		}
		public Card(int value, int suit) {
			Value = value;  Suit = suit;
		}
		public override string ToString() {
			return string.Format("{0}{1}", kValues[Value], kSuits[Suit]);
		}
	}
	
	public class Deck {
		public Card[] Cards;
		public Deck(int seed) {
			var r = new Rand(seed);
			Cards = new Card[52];
			for (int i=0; i < 52; i++)
				Cards[i] = new Card(51 - i);
			for (int i=0; i < 51; i++) {
				int j = 51 - r.Next() % (52 - i);
				Card tmp = Cards[i];  Cards[i] = Cards[j];  Cards[j] = tmp;
			}
		}
		public override string ToString() {
			var sb = new StringBuilder();
			for (int i=0; i < Cards.Length; i++) {
				sb.Append(Cards[i].ToString());
				sb.Append(i % 8 == 7 ? "\n" : " ");
			}
			return sb.ToString();
		}
	}
	
	class Program {
		public static void Main(string[] args) {
			Console.WriteLine("Deck 1\n{0}\n", new Deck(1));
			Console.WriteLine("Deck 617\n{0}\n", new Deck(617));
		}
	}
}
