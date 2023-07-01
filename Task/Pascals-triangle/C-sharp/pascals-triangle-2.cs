using System;
using System.Linq;
using System.Numerics;
using System.Collections.Generic;

namespace RosettaCode
{
	public static class PascalsTriangle
	{		
		public static IEnumerable<BigInteger[]> GetTriangle(int quantityOfRows)
		{
			IEnumerable<BigInteger> range = Enumerable.Range(0, quantityOfRows).Select(num => new BigInteger(num));
			return range.Select(num => GetRow(num).ToArray());
		}

		public static IEnumerable<BigInteger> GetRow(BigInteger rowNumber)
		{
			BigInteger denominator = 1;
			BigInteger numerator = rowNumber;

			BigInteger currentValue = 1;
			for (BigInteger counter = 0; counter <= rowNumber; counter++)
			{
				yield return currentValue;
				currentValue = BigInteger.Multiply(currentValue, numerator--);
				currentValue = BigInteger.Divide(currentValue, denominator++);
			}
			yield break;
		}

		public static string FormatTriangleString(IEnumerable<BigInteger[]> triangle)
		{
			int maxDigitWidth = triangle.Last().Max().ToString().Length;
			IEnumerable<string> rows = triangle.Select(arr =>
					string.Join(" ", arr.Select(array => CenterString(array.ToString(), maxDigitWidth)) )
			);
			int maxRowWidth = rows.Last().Length;
			return string.Join(Environment.NewLine, rows.Select(row => CenterString(row, maxRowWidth)));
		}

		private static string CenterString(string text, int width)
		{
			int spaces = width - text.Length;
			int padLeft = (spaces / 2) + text.Length;
			return text.PadLeft(padLeft).PadRight(width);
		}
	}
}
