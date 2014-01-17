def isNumeric(str: String): Boolean = {
  !throwsNumberFormatException(str.toLong) || !throwsNumberFormatException(str.toDouble)
}

def throwsNumberFormatException(f: => Any): Boolean = {
  try { f; false } catch { case e: NumberFormatException => true }
}
