use Elementwise;

$a = new Elementwise [
	1,2,3,
	4,5,6,
	7,8,9
];

print << "_E";
a  @$a
a OP a
+  @{$a+$a}
-  @{$a-$a}
*  @{$a*$a}
/  @{$a/$a}
^  @{$a**$a}
a OP 5
+  @{$a+5}
-  @{$a-5}
*  @{$a*5}
/  @{$a/5}
^  @{$a**5}
_E
