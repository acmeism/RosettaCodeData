object TextBetween extends App {
    val (thisText, startDelimiter, endDelimiter) = (args(0), args(1),args(2))

  /*
   * textBetween: Get the text between two delimiters
   */
  private def textBetween(thisText: String, startString: String, endString: String): String = {
    var startIndex = 0
    var endIndex = 0
    if (startString != "start")
    {
      startIndex = thisText.indexOf(startString)
      if (startIndex < 0) return ""
      else startIndex = startIndex + startString.length
    }
    if (endString == "end") endIndex = thisText.length
    else {
      endIndex = thisText.indexOf(endString)
      if (endIndex <= 0) return ""
    }

    thisText.substring(startIndex, endIndex)
  } // end method textBetween

  println(textBetween(thisText, startDelimiter, endDelimiter))

}
