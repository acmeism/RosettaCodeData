void main() {
  var s1 = "The quick brown";
  var s2 = "The Quick Brown";
  stdout.printf("== : %s\n", s1 == s2 ? "true" : "false");
  stdout.printf("!= : %s\n", s1 != s2 ? "true" : "false");
  stdout.printf("<  : %s\n", s1 <  s2 ? "true" : "false");
  stdout.printf("<= : %s\n", s1 <= s2 ? "true" : "false");
  stdout.printf(">  : %s\n", s1 >  s2 ? "true" : "false");
  stdout.printf(">= : %s\n", s1 >= s2 ? "true" : "false");
}
