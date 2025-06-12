USE: math.parser
100 <iota> <reversed>
[ dup 1 - [ >dec " bottles of beer" append [ " on the wall" append ] keep ] bi@
  "Take one down, pass it around" -rot
  first CHAR: - = [ 2drop "..." "why's all the rum gone??" ] when ! if leading character is "-" then replace with new string
  4array "\n" join print nl ] each
