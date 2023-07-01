def integrate_left($a; $b; $n; f):
  (($b - $a) / $n) as $h
  | reduce range(0;$n) as $i (0;
      ($a + $i * $h) as $x
      | . + ($x|f) )
  | . * $h;

def integrate_mid($a; $b; $n; f):
  (($b - $a) / $n) as $h
  | reduce range(0;$n) as $i (0;
      ($a + $i * $h) as $x
      | . + (($x + $h/2) | f) )
  | . * $h;

def integrate_right($a; $b; $n; f):
  (($b - $a) / $n) as $h
  | reduce range(1; $n + 1) as $i (0;
      ($a + $i * $h) as $x
      | . +  ($x|f) )
  | . * $h;

def integrate_trapezium($a; $b; $n; f):
  (($b - $a) / $n) as $h
  | reduce range(0;$n) as $i (0;
      ($a + $i * $h) as $x
      | . + ( ($x|f) + (($x + $h)|f)) / 2 )
  | . * $h;

def integrate_simpson($a; $b; $n; f):
  (($b - $a) / $n) as $h
  | reduce range(0;$n) as $i (0;
      ($a + $i * $h) as $x
      | . + ((( ($x|f) + 4 * (($x + ($h/2))|f) + (($x + $h)|f)) / 6)) )
  | . * $h;

def demo($a; $b; $n; f):
 "Left      = \(integrate_left($a;$b;$n;f))",
 "Mid       = \(integrate_mid ($a;$b;$n;f))",
 "Right     = \(integrate_right($a;$b;$n;f))",
 "Trapezium = \(integrate_trapezium($a;$b;$n;f))",
 "Simpson   = \(integrate_simpson($a;$b;$n;f))",
 "" ;

demo(0;    1;     100; .*.*. ),
demo(1;  100;    1000; 1 / . ),
demo(0; 5000; 5000000; .     ),
demo(0; 6000; 6000000; .     )
