/* match entire string against a pattern */
boolean isNumber = "-1234.567".matches("-?\\d+(?:\\.\\d+)?");

/* substitute part of string using a pattern */
String reduceSpaces = "a  b c   d e  f".replaceAll(" +", " ");
