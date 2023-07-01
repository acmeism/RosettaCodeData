import scala.collection.immutable.ListMap

object StringAllSameCharacters {

  /**Transform an input String into an HashMap of its characters and its first occurrence index*/
  def countChar( s : String) : Map[Char, Int] = {
    val mapChar = s.toSeq.groupBy(identity).map{ case (a,b) => a->s.indexOf(a) }
    val orderedMapChar = ListMap(mapChar.toSeq.sortWith(_._2 < _._2):_*)
    orderedMapChar
  }

  /**Check if all the characters of a String are the same given an input Hashmap of it */
  def areAllCharEquals ( mapChar : Map[Char, Int] ) : Boolean = {
    return mapChar.size <= 1
  }

  /**Retrieve the first "breaking" different character of a String*/
  def findFirstDifferentChar ( mapChar : Map[Char, Int] ) : Char = {
    if(areAllCharEquals(mapChar) == false) mapChar.keys.toList(1)
    else 0.toChar
  }

  /**Convert char to hexadecimal values as "0xHEXVALUE" */
  def charToHexString ( c : Char) : String = "0x" + c.toHexString

  /**Display results as asked in the ask*/
  def reportResults( s : String) : String = {
    val mapChar = countChar(s)
    if (areAllCharEquals(mapChar)) s + " -- length " + s.size + " -- contains all the same character."
    else {
      val diffChar = findFirstDifferentChar(mapChar)
      s + " -- length " + s.size +
        " -- contains a different character at index " +
        (s.indexOf(diffChar).toInt+1).toString + " : " + charToHexString(diffChar)
    }
  }

  def main(args: Array[String]): Unit = {
    println(reportResults(""))
    println(reportResults("   "))
    println(reportResults("2"))
    println(reportResults("333"))
    println(reportResults(".55"))
    println(reportResults("tttTTT"))
    println(reportResults("4444 444k"))
  }


}
