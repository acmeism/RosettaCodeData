# `whilst/2` is like `while/2` but emits the final term rather than the first one
def whilst(cond; update):
     def _whilst:
         if cond then update | (., _whilst) else empty end;
     _whilst;

# module Sandpile

def new($a): {$a};

def neighbors: [
   [1, 3], [0, 2, 4], [1, 5],
   [0, 4, 6], [1, 3, 5, 7], [2, 4, 8],
   [3, 7], [4, 6, 8], [5, 7]
];

def add($other):
  . as $in
  | reduce range(0; .a|length) as $i ($in; .a[$i] += $other.a[$i] );

def isStable:
  all(.a[]; . <= 3);

# just topple once so we can observe intermediate results
def topple:
  last(
    label $out
    | foreach range(0; .a|length) as $i (.;
        if .a[$i] > 3
        then .a[$i] += -4
        | reduce neighbors[$i][] as $j (.; .a[$j] += 1)
        | ., break $out
       else .
       end ) );

def tos:
  . as $in
  | reduce range(0;3) as $i ("";
      reduce range(0;3) as $j (.;
        . + " \($in.a[3*$i + $j])" )
      | . +"\n" );

# Some sandpiles:
def s1: new([1, 2, 0, 2, 1, 1, 0, 1, 3]);
def s2: new([2, 1, 3, 1, 0, 1, 0, 1, 0]);
def s3: new([range(0;9)|3]);
def s4: new([4, 3, 3, 3, 1, 2, 0, 2, 3]);

def s3_id: new([2, 1, 2, 1, 0, 1, 2, 1, 2]);

# For brevity
def report_add($s1; $s2):
  "\($s1|tos)\nplus\n\n\($s2|tos)\nequals\n\n\($s1 | add($s2) | until(isStable; topple) | tos)";

def task1:
  "Avalanche of topplings:\n",
  (s4
   | (., whilst(isStable|not; topple))
   | tos ) ;

def task2:
  def s3_a: s1 | add(s2);
  def s3_b: s2 | add(s1);

  "Commutative additions:\n",
  ( (s3_b | until(isStable; topple)) as $s3_b
    | report_add(s1; s2),
      "and\n\n\(s2|tos)\nplus\n\n\(s1|tos)\nalso equals\n\n\($s3_b|tos)" ) ;

def task3:
  "Addition of identity sandpile:\n",
  report_add(s3; s3_id);

def task4:
  "Addition of identities:\n",
  report_add(s3_id; s3_id);

task1, task2, task3, task4
