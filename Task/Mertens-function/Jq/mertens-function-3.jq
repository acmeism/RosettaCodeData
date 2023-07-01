# Task 0:
def mertens_number:
  mertensNumbers[.-1];

def task1:
  "The first \(.) Mertens numbers are:",
   (mertensNumbers | nwise(10) | map(lpad(2)) | join(" ") );

def task2:
  . as $n
  | sum(mertensNumbers[] | select(.==0) | 1)
  | "M(n) is zero \(.) times for 1 <= n <= \($n)\n";

def task3:
  . as $n
  | mertensNumbers
  | count_crossings(0)
  | "M(n) crosses zero \(.) times for 1 <= n <= \($n).\n" ;

(99|task1),
"",
(1000 | (task2, task3))
