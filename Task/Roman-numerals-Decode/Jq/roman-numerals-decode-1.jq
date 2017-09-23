def fromRoman:
  def addRoman(n):
    if length == 0 then n
    elif startswith("M")  then .[1:] | addRoman(1000 + n)
    elif startswith("CM") then .[2:] | addRoman(900 + n)
    elif startswith("D")  then .[1:] | addRoman(500 + n)
    elif startswith("CD") then .[2:] | addRoman(400 + n)
    elif startswith("C")  then .[1:] | addRoman(100 + n)
    elif startswith("XC") then .[2:] | addRoman(90 + n)
    elif startswith("L")  then .[1:] | addRoman(50 + n)
    elif startswith("XL") then .[2:] | addRoman(40 + n)
    elif startswith("X")  then .[1:] | addRoman(10 + n)
    elif startswith("IX") then .[2:] | addRoman(9 + n)
    elif startswith("V")  then .[1:] | addRoman(5 + n)
    elif startswith("IV") then .[2:] | addRoman(4 + n)
    elif startswith("I")  then .[1:] | addRoman(1 + n)
    else
      error("invalid Roman numeral: " + tostring)
    end;
  addRoman(0);
