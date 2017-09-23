def demo(x):
  def nth_root(n): log / n | exp;
  def lpad(n): tostring | (n - length) * " " + .;
  . as $in
  | "\(x)^(1/\(lpad(5))): \(x|nth_root($in)|lpad(18)) vs \(x|iterative_nth_root($in; 1e-10)|lpad(18)) vs \(x|iterative_nth_root($in; 0))"
;

# 5^m for various values of n:
"5^(1/   n):             builtin       precision=1e-10           precision=0",
( (1,-5,-3,-1,1,3,5,1000,10000) | demo(5))
