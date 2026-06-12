def walshMatrix:
  . as $n
  | { walsh: matrix($n; $n; 0) }
  | .walsh[0][0] = 1
  | .k = 1
  | until (.k >= $n;
      .k as $k
      | reduce range (0; $k) as $i (.;
          reduce range (0; $k) as $j (.;
            .walsh[$i][$j] as $wij
            | .walsh[$i+$k][$j] = $wij
            | .walsh[$i][$j+$k] = $wij
            | .walsh[$i+$k][$j+$k] = -$wij ))
      | .k += .k )
  | .walsh ;

## The tasks
def task1:
  (2, 4, 5) as $order
  | pow(2; $order)
  | "Walsh matrix - order \($order) (\(.) x \(.)), natural order:",
    (walshMatrix | mprint(2)),
    "";

def task2:
  (2, 4, 5) as $order
  | pow(2; $order)
  | "Walsh matrix - order \($order) (\(.) x \(.)), sequency order:",
     (walshMatrix | sort_by( signChanges ) | mprint(2)),
     "";

def task3:
  5 as $order
  | pow(2; $order)
  | "Walsh matrix - order \($order) (\(.) x \(.)), natural order:",
    (walshMatrix | map(map(color)) | cprint),
    "";

def task4:
  5 as $order
  | pow(2; $order)
  | "Walsh matrix - order \($order) (\(.) x \(.)), sequency order:",
     (walshMatrix | sort_by( signChanges ) | map(map(color)) | cprint),
     "";

task1, task2, task3, task4
