BEGIN {
  RS="[0-9]+[^0-9]"
  final = "";
}
{
  match(RT, /([0-9]+)([^0-9])/, r)
  for(i=0; i < int(r[1]); i++) {
    final = final r[2]
  }
}
END {
  print final
}
