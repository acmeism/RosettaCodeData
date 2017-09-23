def example:
  def pow(i): . as $in | reduce range(0;i) as $i (1; . * $in);
  def poly(a;b;c): plus( plus( multiply(a; multiply(.;.)); multiply(b;.)); c);
  def abs: if . < 0 then -. else . end;
  def zero(z):
    if z == 0 then 0
    else (magnitude(z)|abs) as $zero
    | if $zero < 1e-10 then "+0" else $zero end
    end;
  def lpad(n): tostring | (n - length) * " " + .;

  range(0; 13) as $i
  | (- (10|pow($i))) as $b
  | quadratic_roots(1; $b; 1) as $x
  | $x | poly(1; $b; 1) as $zero
  | "\($i|lpad(4)): error = \(zero($zero)|lpad(18)) x=\($x)"
;

example
