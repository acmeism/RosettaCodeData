**
** converts a number to its roman numeral representation
**
class RomanNumerals
{

  private Str digit(Str x, Str y, Str z, Int i)
  {
    switch (i)
    {
      case 1: return x
      case 2: return x+x
      case 3: return x+x+x
      case 4: return x+y
      case 5: return y
      case 6: return y+x
      case 7: return y+x+x
      case 8: return y+x+x+x
      case 9: return x+z
    }
    return ""
  }

  Str toRoman(Int i)
  {
    if (i>=1000) { return "M" + toRoman(i-1000) }
    if (i>=100) { return digit("C", "D", "M", i/100) + toRoman(i%100) }
    if (i>=10) { return digit("X", "L", "C", i/10) + toRoman(i%10) }
    if (i>=1) { return digit("I", "V", "X", i) }
    return ""
  }

  Void main()
  {
    2000.times |i| { echo("$i = ${toRoman(i)}") }
  }

}
