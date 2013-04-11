   keys: !10   / 0..9
   split:{1_'(&x=y)_ x:y,x}
   vals:split["zero one two three four five six seven eight nine";" "]

   s:{`$$x}  / convert to symbol
   d:. (s'keys),'s'vals
.((`"0";`zero;)
  (`"1";`one;)
  (`"2";`two;)
  (`"3";`three;)
  (`"4";`four;)
  (`"5";`five;)
  (`"6";`six;)
  (`"7";`seven;)
  (`"8";`eight;)
  (`"9";`nine;))

   $d[s 1] / leading "$" converts back to string
"one"
