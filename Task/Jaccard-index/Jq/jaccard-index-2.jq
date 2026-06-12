def rjaccardIndex(x; y):
  def i(a;b): a - (a-b);
  def u(a;b): a + (b - i(a;b)) | unique;

  def idivide($i; $j):
    if $i == 0 then "0"
    else gcd($i;$j) as $d
    | if $j == $d then "\($i/$d)"
      else "\($i/$d)/\($j/$d)"
      end
    end;

  if (x|length) == 0 and (y|length) == "0" then "1"
  else idivide( i(x;y)|length; u(x;y)|length )
  end;

def a : [];
def b : [1, 2, 3, 4, 5];
def c : [1, 3, 5, 7, 9];
def d : [2, 4, 6, 8, 10];
def e : [2, 3, 5, 7];
def f : [8];

def task:
  def tidy: map(lpad(4))|join(" ");

  [a,b,c,d,e,f] as $sets
  | [range(0;$sets|length) | [. + 97] | implode] as $names
  | ([""] + $names | tidy),
    (range(0; $sets|length) as $i
     | ([$i + 97] | implode) as $name
     | $sets[$i] as $x
     | $sets | map(rjaccardIndex($x; .)) | tidy
     | "  \($name): \(.)" ) ;

task
