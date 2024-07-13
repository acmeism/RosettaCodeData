### Generic utilities

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;
def rpad($len): tostring | ($len - length) as $l | . + (" " * $l);

# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be a pair of integers.
def divmod($i; $j):
  ($i % $j) as $mod
  | [($i - $mod) / $j, $mod] ;

def whilst(cond; update):
     def _whilst:
         if cond then update | (., _whilst) else empty end;
     _whilst;


### Continued fractions

# $a/$b
def toContFrac($a; $b):
  {$a,$b}
  | whilst( .b != 0;
      divmod(.a; .b) as [$d, $r]
      | .a = .b
      | .b = $r
      | .d = $d
      | if .a == 1 then .b = 0 end)
  | .d ;

def examples: [
  {heading: "Examples ->",
   group:   [ [1, 2], [3, 1], [23, 8], [13, 11], [22, 7], [-151, 77] ],
   lengths: [4,2] },

  {heading: "Sqrt(2) ->",
   group:   [ [14142, 10000], [141421, 100000], [1414214, 1000000], [14142136, 10000000] ],
   lengths: [8,8]},

  {heading: "Pi ->",
   group:   [ [31, 10], [314, 100], [3142, 1000], [31428, 10000], [314285, 100000], [3142857, 1000000],
              [31428571, 10000000], [314285714,100000000]],
   lengths: [9, 9] }
];

def task:
  examples[]
  | .lengths as $lengths
  | .heading,
    (foreach .group[] as [$a, $b] (.;
           .emit = "\($a|lpad($lengths[0])) / \($b|rpad($lengths[1]))"
           | .emit += " = " + ([toContFrac($a;$b)] | join(" "))  )
         | .emit ),
    "";

task
