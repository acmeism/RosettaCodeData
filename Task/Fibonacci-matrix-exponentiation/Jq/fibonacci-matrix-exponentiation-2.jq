# Input: n
# Output: Fib(2^n)
def Fib2pN:
  # in: [p, Fn-1, Fn] where n==2^p
  # out: [2p, F(2n-1),F(2n)]
  def fibonacci_recurrence:
    def sq: .*.;
      . as [$p, $fprev, $f]
      | [1+$p, ($f|sq) + ($fprev|sq), (2*$fprev + $f)*$f];
  . as $n
  | [0,0,1]
  | until( .[0] >= $n;  fibonacci_recurrence)
  | .[2] ;


16, 32
| . as $i
| Fib2pN
| tostring
| "The digits of the 2^\($i)th Fibonacci number (with string length \(length)) are:",
   "  First 20 : \(.[0:20])",
   "  Final 20 : \(.[-20:])",
   ""
