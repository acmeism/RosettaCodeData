BEGIN {
  a="BALL"
  b="BELL"

  if (a == b) { print "The strings are equal" }
  if (a != b) { print "The strings are not equal" }
  if (a  > b) { print "The first string is lexically after than the second" }
  if (a  < b) { print "The first string is lexically before than the second" }
  if (a >= b) { print "The first string is not lexically before than the second" }
  if (a <= b) { print "The first string is not lexically after than the second" }

  # to make a case insensitive comparison convert both strings to the same lettercase:
  a="BALL"
  b="ball"
  if (tolower(a) == tolower(b)) { print "The first and second string are the same disregarding letter case" }

}
