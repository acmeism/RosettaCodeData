BEGIN {
  a = "alphaBETA";
  print toupper(substr(a, 1, 1)) tolower(substr(a, 2))
}
