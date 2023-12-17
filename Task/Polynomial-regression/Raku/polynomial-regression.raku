use MultiVector;

constant @x1 = <0 1 2 3 4 5 6 7 8 9 10>;
constant @y = <1 6 17 34 57 86 121 162 209 262 321>;

constant $x0 = [+] @e[^@x1];
constant $x1 = [+] @x1 Z* @e;
constant $x2 = [+] @x1 »**» 2  Z* @e;

constant $y  = [+] @y Z* @e;

.say for
  $y∧$x1∧$x2/($x0∧$x1∧$x2),
  $y∧$x2∧$x0/($x1∧$x2∧$x0),
  $y∧$x0∧$x1/($x2∧$x0∧$x1);
