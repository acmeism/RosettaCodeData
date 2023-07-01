using System;
using System.Collections.Generic;
using System.Linq;

namespace HofstadterFigureFigure
{
	class HofstadterFigureFigure
	{
		readonly List<int> _r = new List<int>() {1};
		readonly List<int> _s = new List<int>();

		public IEnumerable<int> R()
		{
			int iR = 0;
			while (true)
			{
				if (iR >= _r.Count)
				{
					Advance();
				}
				yield return _r[iR++];
			}
		}

		public IEnumerable<int> S()
		{
			int iS = 0;
			while (true)
			{
				if (iS >= _s.Count)
				{
					Advance();
				}
				yield return _s[iS++];
			}
		}

		private void Advance()
		{
			int rCount = _r.Count;
			int oldR = _r[rCount - 1];
			int sVal;
			
			// Take care of first two cases specially since S won't be larger than R at that point
			switch (rCount)
			{
				case 1:
					sVal = 2;
					break;
				case 2:
					sVal = 4;
					break;
				default:
					sVal = _s[rCount - 1];
					break;
			}
			_r.Add(_r[rCount - 1] + sVal);
			int newR = _r[rCount];
			for (int iS = oldR + 1; iS < newR; iS++)
			{
				_s.Add(iS);
			}
		}
	}

	class Program
	{
		static void Main()
		{
			var hff = new HofstadterFigureFigure();
			var rs = hff.R();
			var arr = rs.Take(40).ToList();

			foreach(var v in arr.Take(10))
			{
				Console.WriteLine("{0}", v);
			}

			var hs = new HashSet<int>(arr);
			hs.UnionWith(hff.S().Take(960));
			Console.WriteLine(hs.Count == 1000 ? "Verified" : "Oops!  Something's wrong!");
		}
	}
}
