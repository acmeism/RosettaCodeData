import strutils

var s1: string = "The quick brown"
var s2: string = "The Quick Brown"
echo("== : ", s1 == s2)
echo("!= : ", s1 != s2)
echo("< : ", s1 < s2)
echo("<= : ", s1 <= s2)
echo("> : ", s1 > s2)
echo(">= : ", s1 >= s2)
# cmpIgnoreCase(a, b) => 0 if a == b; < 0 if a < b; > 0 if a > b
echo("cmpIgnoreCase :", s1.cmpIgnoreCase s2)
