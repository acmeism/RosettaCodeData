#
# countsubstring(string, pattern)
#   Returns number of occurrences of pattern in string
#   Pattern treated as a literal string (regex characters not expanded)
#
function countsubstring(str, pat,    len, i, c) {
  c = 0
  if( ! (len = length(pat) ) )
    return 0
  while(i = index(str, pat)) {
    str = substr(str, i + len)
    c++
  }
  return c
}
#
# countsubstring_regex(string, regex_pattern)
#   Returns number of occurrences of pattern in string
#   Pattern treated as regex
#
function countsubstring_regex(str, pat,    c) {
  c = 0
  c += gsub(pat, "", str)
  return c
}
BEGIN {
  print countsubstring("[do&d~run?d!run&>run&]", "run&")
  print countsubstring_regex("[do&d~run?d!run&>run&]", "run[&]")
  print countsubstring("the three truths","th")
}
