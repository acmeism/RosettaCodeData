using System;
using System.Text;
using System.Collections.Generic;

public class BalancedTernary
{
	public static void Main()
	{
		BalancedTernary a = new BalancedTernary("+-0++0+");
		System.Console.WriteLine("a: " + a + " = " + a.ToLong());
		BalancedTernary b = new BalancedTernary(-436);
		System.Console.WriteLine("b: " + b + " = " + b.ToLong());
		BalancedTernary c = new BalancedTernary("+-++-");
		System.Console.WriteLine("c: " + c + " = " + c.ToLong());
		BalancedTernary d = a * (b - c);
		System.Console.WriteLine("a * (b - c): " + d + " = " + d.ToLong());
	}

	private enum BalancedTernaryDigit
	{
		MINUS = -1,
		ZERO = 0,
		PLUS = 1
	}

	private BalancedTernaryDigit[] value;

	// empty = 0
	public BalancedTernary()
	{
		this.value = new BalancedTernaryDigit[0];
	}

	// create from String
	public BalancedTernary(String str)
	{
		this.value = new BalancedTernaryDigit[str.Length];
		for (int i = 0; i < str.Length; ++i)
		{
			switch (str[i])
			{
				case '-':
					this.value[i] = BalancedTernaryDigit.MINUS;
					break;
				case '0':
					this.value[i] = BalancedTernaryDigit.ZERO;
					break;
				case '+':
					this.value[i] = BalancedTernaryDigit.PLUS;
					break;
				default:
					throw new ArgumentException("Unknown Digit: " + str[i]);
			}
		}
		Array.Reverse(this.value);
	}

	// convert long integer
	public BalancedTernary(long l)
	{
		List<BalancedTernaryDigit> value = new List<BalancedTernaryDigit>();
		int sign = Math.Sign(l);
		l = Math.Abs(l);
		
		while (l != 0)
		{
			byte rem = (byte)(l % 3);
			switch (rem)
			{
				case 0:
				case 1:
					value.Add((BalancedTernaryDigit)rem);
					l /= 3;
					break;
				case 2:
					value.Add(BalancedTernaryDigit.MINUS);
					l = (l + 1) / 3;
					break;
			}
		}

		this.value = value.ToArray();
		if (sign < 0)
		{
			this.Invert();
		}
	}

	// copy constructor
	public BalancedTernary(BalancedTernary origin)
	{
		this.value = new BalancedTernaryDigit[origin.value.Length];
		Array.Copy(origin.value, this.value, origin.value.Length);
	}

	// only for internal use
	private BalancedTernary(BalancedTernaryDigit[] value)
	{
		int end = value.Length - 1;
		while (value[end] == BalancedTernaryDigit.ZERO)
			--end;
		this.value = new BalancedTernaryDigit[end + 1];
		Array.Copy(value, this.value, end + 1);
	}

	// invert the values
	private void Invert()
	{
		for (int i=0; i < this.value.Length; ++i)
		{
			this.value[i] = (BalancedTernaryDigit)(-(int)this.value[i]);
		}
	}

	// convert to string
	override public String ToString()
	{
		StringBuilder result = new StringBuilder();
		for (int i = this.value.Length - 1; i >= 0; --i)
		{
			switch (this.value[i])
			{
				case BalancedTernaryDigit.MINUS:
					result.Append('-');
					break;
				case BalancedTernaryDigit.ZERO:
					result.Append('0');
					break;
				case BalancedTernaryDigit.PLUS:
					result.Append('+');
					break;
			}
		}
		return result.ToString();
	}

	// convert to long
	public long ToLong()
	{
		long result = 0;
		int digit;
		for (int i = 0; i < this.value.Length; ++i)
		{
			result += (long)this.value[i] * (long)Math.Pow(3.0, (double)i);
		}
		return result;
	}

	// unary minus
	public static BalancedTernary operator -(BalancedTernary origin)
	{
		BalancedTernary result = new BalancedTernary(origin);
		result.Invert();
		return result;
	}

	// addition of digits
	private static BalancedTernaryDigit carry = BalancedTernaryDigit.ZERO;
	private static BalancedTernaryDigit Add(BalancedTernaryDigit a, BalancedTernaryDigit b)
	{
		if (a != b)
		{
			carry = BalancedTernaryDigit.ZERO;
			return (BalancedTernaryDigit)((int)a + (int)b);
		}
		else
		{
			carry = a;
			return (BalancedTernaryDigit)(-(int)b);
		}
	}

	// addition of balanced ternary numbers
	public static BalancedTernary operator +(BalancedTernary a, BalancedTernary b)
	{
		int maxLength = Math.Max(a.value.Length, b.value.Length);
		BalancedTernaryDigit[] resultValue = new BalancedTernaryDigit[maxLength + 1];
		for (int i=0; i < maxLength; ++i)
		{
			if (i < a.value.Length)
			{
				resultValue[i] = Add(resultValue[i], a.value[i]);
				resultValue[i+1] = carry;
			}
			else
			{
				carry = BalancedTernaryDigit.ZERO;
			}
			
			if (i < b.value.Length)
			{
				resultValue[i] = Add(resultValue[i], b.value[i]);
				resultValue[i+1] = Add(resultValue[i+1], carry);
			}
		}
		return new BalancedTernary(resultValue);
	}

	// subtraction of balanced ternary numbers
	public static BalancedTernary operator -(BalancedTernary a, BalancedTernary b)
	{
		return a + (-b);
	}

	// multiplication of balanced ternary numbers
	public static BalancedTernary operator *(BalancedTernary a, BalancedTernary b)
	{
		BalancedTernaryDigit[] longValue = a.value;
		BalancedTernaryDigit[] shortValue = b.value;
		BalancedTernary result = new BalancedTernary();
		if (a.value.Length < b.value.Length)
		{
			longValue = b.value;
			shortValue = a.value;
		}

		for (int i = 0; i < shortValue.Length; ++i)
		{
			if (shortValue[i] != BalancedTernaryDigit.ZERO)
			{
				BalancedTernaryDigit[] temp = new BalancedTernaryDigit[i + longValue.Length];
				for (int j = 0; j < longValue.Length; ++j)
				{
					temp[i+j] = (BalancedTernaryDigit)((int)shortValue[i] * (int)longValue[j]);
				}
				result = result + new BalancedTernary(temp);
			}
		}
		return result;
	}
}
