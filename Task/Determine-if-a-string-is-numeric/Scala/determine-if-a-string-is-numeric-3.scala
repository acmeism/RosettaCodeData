def isNumeric2(str: String): Boolean = {
  str.matches(s"""[+-]?((\d+(e\d+)?[lL]?)|(((\d+(\.\d*)?)|(\.\d+))(e\d+)?[fF]?))""")
}
