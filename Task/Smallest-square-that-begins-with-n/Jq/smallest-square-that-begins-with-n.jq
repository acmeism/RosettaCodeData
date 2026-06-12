def smallest_square_beginning_with_n:
  tostring as $n
  | first (range(0; infinite)
           | .*.
           | select(tostring | startswith($n) ))  ;

range(1; 50)
| . as $i
| smallest_square_beginning_with_n
| "\(.) is \(sqrt)²"
