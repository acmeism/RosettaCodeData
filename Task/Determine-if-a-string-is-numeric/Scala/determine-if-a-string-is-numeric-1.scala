import scala.util.control.Exception.allCatch

def isNumber(s: String): Boolean = (allCatch opt s.toDouble).isDefined
