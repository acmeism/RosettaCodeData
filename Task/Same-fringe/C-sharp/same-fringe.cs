using System;
using System.Collections.Generic;
using System.Linq;

namespace Same_Fringe
{
	class Program
	{
		static void Main()
		{
			var rnd = new Random(110456);
			var randList = Enumerable.Range(0, 20).Select(i => rnd.Next(1000)).ToList();
			var bt1 = new BinTree<int>(randList);
			// Shuffling will create a tree with the same values but different topology
			Shuffle(randList, 428);
			var bt2 = new BinTree<int>(randList);
			Console.WriteLine(bt1.CompareTo(bt2) ? "True compare worked" : "True compare failed");
			// Insert a 0 in the first tree which should cause a failure
			bt1.Insert(0);
			Console.WriteLine(bt1.CompareTo(bt2) ? "False compare failed" : "False compare worked");
		}

		static void Shuffle<T>(List<T> values, int seed)
		{
			var rnd = new Random(seed);

			for (var i = 0; i < values.Count - 2; i++)
			{
				var iSwap = rnd.Next(values.Count - i) + i;
				var tmp = values[iSwap];
				values[iSwap] = values[i];
				values[i] = tmp;
			}
		}
	}

	// Define other methods and classes here
	class BinTree<T> where T:IComparable
	{
		private BinTree<T> _left;
		private BinTree<T> _right;
		private T _value;

		private BinTree<T> Left
		{
			get { return _left; }
		}

		private BinTree<T> Right
		{
			get { return _right; }
		}

		// On interior nodes, any value greater than or equal to Value goes in the
		// right subtree, everything else in the left.
		private T Value
		{
			get { return _value; }
		}

		public bool IsLeaf { get { return Left == null; } }

		private BinTree(BinTree<T> left, BinTree<T> right, T value)
		{
			_left = left;
			_right = right;
			_value = value;
		}

		public BinTree(T value) : this(null, null, value) { }

		public BinTree(IEnumerable<T> values)
		{
			// ReSharper disable PossibleMultipleEnumeration
			_value = values.First();
			foreach (var value in values.Skip(1))
			{
				Insert(value);
			}
			// ReSharper restore PossibleMultipleEnumeration
		}

		public void Insert(T value)
		{
			if (IsLeaf)
			{
				if (value.CompareTo(Value) < 0)
				{
					_left = new BinTree<T>(value);
					_right = new BinTree<T>(Value);
				}
				else
				{
					_left = new BinTree<T>(Value);
					_right = new BinTree<T>(value);
					_value = value;
				}
			}
			else
			{
				if (value.CompareTo(Value) < 0)
				{
					Left.Insert(value);
				}
				else
				{
					Right.Insert(value);
				}
			}
		}

		public IEnumerable<T> GetLeaves()
		{
			if (IsLeaf)
			{
				yield return Value;
				yield break;
			}
			foreach (var val in Left.GetLeaves())
			{
				yield return val;
			}
			foreach (var val in Right.GetLeaves())
			{
				yield return val;
			}
		}

		internal bool CompareTo(BinTree<T> other)
		{
			return other.GetLeaves().Zip(GetLeaves(), (t1, t2) => t1.CompareTo(t2) == 0).All(f => f);
		}
	}
}
