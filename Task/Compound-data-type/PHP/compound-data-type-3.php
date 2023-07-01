# Using class
class Point {
  function __construct($x, $y) { $this->x = $x; $this->y = $y; }
  function __tostring() { return $this->x . ' ' . $this->y . "\n"; }
}
$point = new Point(1, 2);
echo $point; # will call __tostring() in later releases of PHP 5.2; before that, it won't work so good.
