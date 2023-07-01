def quibble( s:List[String] ) = s match {
  case m if m.isEmpty => "{}"
  case m if m.length < 3 => m.mkString("{", " and ", "}")
  case m => "{" + m.init.mkString(", ") + " and " + m.last + "}"
}

// A little test...
{
  println( quibble( List() ) )
  println( quibble( List("ABC") ) )
  println( quibble( List("ABC","DEF") ) )
  println( quibble( List("ABC","DEF","G","H") ) )
}
