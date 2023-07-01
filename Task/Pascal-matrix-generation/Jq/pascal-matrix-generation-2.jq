# n is input
def pascal_upper:
    . as $n
    | matrix($n; $n; 0)
    | .[0] = [range(0; $n) | 1 ]
    | reduce range(1; $n) as $i
        (.; reduce range($i; $n) as $j
              (.; .[$i][$j] = .[$i-1][$j-1] + .[$i][$j-1]) ) ;

def pascal_lower:
  pascal_upper | transpose ;

# n is input
def pascal_symmetric:
    . as $n
    | matrix($n; $n; 1)
    | reduce range(1; $n) as $i
        (.; reduce range(1; $n) as $j
              (.; .[$i][$j] = .[$i-1][$j] + .[$i][$j-1]) ) ;
