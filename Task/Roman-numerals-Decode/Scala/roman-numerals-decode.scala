def fromRoman( r:String ) : Int = {
  val arabicNumerals = List("CM"->900,"M"->1000,"CD"->400,"D"->500,"XC"->90,"C"->100,
                            "XL"->40,"L"->50,"IX"->9,"X"->10,"IV"->4,"V"->5,"I"->1)	

  var s = r
  arabicNumerals.foldLeft(0){ (n,t) => {
    val l = s.length; s = s.replaceAll(t._1,""); val c = (l - s.length)/t._1.length  // Get the frequency
    n + (c*t._2)  // Add the arabic numerals up
  } }
}

// Here is a another version that does a simple running sum:
def fromRoman2(s: String) : Int = {
    val numerals = Map('I' -> 1, 'V' -> 5, 'X' -> 10, 'L' -> 50, 'C' -> 100, 'D' -> 500, 'M' -> 1000)

    s.toUpperCase.map(numerals).foldLeft((0,0)) {
      case ((sum, last), curr) =>  (sum + curr + (if (last < curr) -2*last else 0), curr) }._1
  }
}

// A small test
def test( roman:String ) = println( roman + " => " + fromRoman( roman ) )

test("MCMXC")
test("MMVIII")
test("MDCLXVI")
