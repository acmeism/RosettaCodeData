object CollapsibleString {

  /**Collapse a string (if possible)*/
  def collapseString (s : String) : String = {
    var res = s
    var isOver = false
    var i = 0
    if(res.size == 0) res
    else while(!isOver){
      if(res(i) == res(i+1)){
        res = res.take(i) ++ res.drop(i+1)
        i-=1
      }
      i+=1
      if(i==res.size-1) isOver = true
    }
    res
  }

  /**Check if a string is collapsible*/
  def isCollapsible (s : String) : Boolean = collapseString(s).length != s.length

  /**Display results as asked in the task*/
  def reportResults (s : String) : String = {
    val sCollapsed = collapseString(s)
    val originalRes = "ORIGINAL  : length = " + s.length() + ", string = «««" + s + "»»»"
    val collapsedRes = "COLLAPSED : length = " + sCollapsed.length() + ", string = «««" + sCollapsed + "»»»"
    //In order to avoid useless computations, the function isCollapsible isn't called
    if(s.length != sCollapsed.length) originalRes + "\n" + collapsedRes + "\n" + "This string IS collapsible !"
    else originalRes + "\n" + collapsedRes + "\n" + "This string is NOT collapsible !"
  }



  def main(args: Array[String]): Unit = {
    println(reportResults(""))
    println("------------")
    println(reportResults("\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln "))
    println("------------")
    println(reportResults("..1111111111111111111111111111111111111111111111111111111111111117777888"))
    println("------------")
    println(reportResults("I never give 'em hell, I just tell the truth, and they think it's hell. "))
    println("------------")
    println(reportResults("                                                    --- Harry S Truman  "))
    println("------------")
    println(reportResults("The better the 4-wheel drive, the further you'll be from help when ya get stuck!"))
    println("------------")
    println(reportResults("headmistressship"))
    println("------------")
    println(reportResults("aardvark"))
  }


}
