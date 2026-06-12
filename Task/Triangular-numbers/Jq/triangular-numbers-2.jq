def figurate($r; $n): binomial($n + $r -1; $r);

def triangular: binomial(.+1;2);

# r=2
def triangulars: foreach range(0; infinite) as $i (0; . + $i);

# r=3
def tetrahedrals: foreach triangulars as $t (0; . + $t);

# r=4
def pentatopics:  foreach tetrahedrals as $t (0; . + $t);

# input: r
def figurates:
  . as $r
  | if $r == 2 then triangulars
    else foreach ($r - 1 |figurates) as $t (0; . + $t)
    end;

# r=12
def twelveSimplexes: 12 | figurates;

###  r-simplex roots

def triangularRoot: ((8*. + 1 | sqrt) -1) /2;

def tetrahedralRoot:
  def term(sign):
     (3 * .) as $y
     | ($y + sign * ( (($y*$y) - (1/27))|sqrt)) | cbrt;
  term(1) + term(-1) -1;

def pentatopicRoot:
   (((5 + 4 * (( 24*. + 1)|sqrt)) | sqrt) - 3) / 2;

def xs: [7140, 21408696, 26728085384, 14545501785001];

def tasks:
  def round($ndec): pow(10;$ndec) as $p | . * $p | round / $p;
  def r: round(4) | lpad(12);

  def s(stream): limit(30; neatly(stream; 5; 8));
  "The first 30 triangular numbers are:",    s(triangulars),
  "\nThe first 30 tetrahedral numbers are:", s(tetrahedrals),
  "\nThe first 30 pentatopic numbers are:",  s(pentatopics),
  "\nThe first 30 12-simplex numbers are:",  neatly(limit(30; twelveSimplexes); 5; 12),

  "",
  "Approximate r-simplex roots:",
  "\("x "|lpad(15)) triangularRoot tetrahedralRoot  pentatopicRoot",
  (xs[]
   | "\(lpad(15)): \(triangularRoot|r) \(tetrahedralRoot|r) \(pentatopicRoot|r)")

  ;

tasks
