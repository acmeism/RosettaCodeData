def toRoman( v:Int ) : String = {
  val romanNumerals = List(1000->"M",900->"CM",500->"D",400->"CD",100->"C",90->"XC",
                           50->"L",40->"XL",10->"X",9->"IX",5->"V",4->"IV",1->"I")	

  var n = v
  romanNumerals.foldLeft(""){(s,t) => {val c = n/t._1; n = n-t._1*c;  s + (t._2 * c) } }
}

// A small test
def test( arabic:Int ) = println( arabic + " => " + toRoman( arabic ) )

test(1990)
test(2008)
test(1666)
