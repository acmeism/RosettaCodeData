### General utilities
def array($n): . as $in | [range(0;$n)|$in];

def count(s): reduce s as $_ (0; .+1);

# Is . equal to the number of items in the (possibly empty) stream?
def countEq(s):
   . == count(limit(. + 1; s));

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

### Solitaire

# Emit a stream of the relevant triples for a triangle of the given $height,
# specifically [$x, $over, $y] for $x < $y
def triples($height):
  def triples: range(0; length - 2) as $i | .[$i: $i+3];
  def stripes($n):
     def next:
       . as [$r1, $r2, $r3]
       | ($r3[-1]+1) as $x
       | [$r2, $r3, [range($x; $x + ($r3|length) + 1)]];
     limit($n; recurse(next)) ;

  def lefts:
    . as [$r1, $r2, $r3]
    | range(0; $r1|length) as $i
    | [$r1[$i], $r2[$i], $r3[$i]];
  def rights:
    . as [$r1, $r2, $r3]
    | range(0; $r1|length) as $i
    | [$r1[$i], $r2[$i+1], $r3[$i+2]];

  ($height * ($height+1) / 2) as $max
  | [[1], [2,3], [4,5,6]] | stripes($height)
  | . as [$r1, $r2, $r3]
  | ($r1|triples),
    (if $r3[-1] <= $max then lefts, rights else empty end) ;

# For depth <= 10, use single characters to represent pegs, e.g. A for 10.
# Input: {depth, board}
def drawBoard:
  def hex: [if . < 10 then 48 + . else 55 + . end] | implode;
  def p: map(. + " ") | add;
  # Generate the sequence [$i, $n] for the hole numbers of the left-hand side
  def seq: recurse( .[1] += .[0] |  .[0] += 1) | .[1] += 1;

  .depth as $depth
  |  def tr: if $depth > 11 then lpad(3) elif . == "-" then . else hex end;
  [range(0; 1 + ($depth * ($depth + 1) / 2)) as $i | if .board[$i] then $i else "-" end | tr]
  | limit($depth; ([1,0] | seq) as [$n, $s] | ((1 + $depth - $n)*" ") + (.[$s:$s+$n] | p )) ;

# "All solutions"
# Input: as produced by init($depth; $emptyStart)
def solve:
  def solved:
    .board as $board
    | 1 | countEq($board[] | select(.)) ;

  [triples(.depth)] as $triples  # cache the triples
  | def solver:
      # move/3 tries in both directions
      # It is assumed that .board($over) is true
      def move($peg; $over; $source):
        if (.board[$peg] == false) and .board[$source]
        then .board[$peg]    = true
        | .board[$source] = false
        | .board[$over]   = false
        | .solutions += [ [$peg, $over, $source] ]
        | solver
        | if .emit == true then .
          else # revert
            .solutions |= .[:-1]
          | .board[$peg]    = false
          | .board[$source] = true
          | .board[$over]   = true
          end
        end ;
      if solved then .emit = true
      else
        foreach $triples[] as [$x, $over, $y] (.;
          if .board[$over]
          then move($x; $over; $y),
               move($y; $over; $x)
          else .
          end )
        | select(.emit)
      end;
  solver;

# .board[0] is a dummy position
def init($depth; $emptyStart):
  { $depth,
    board: (true | array(1 + $depth * (1+$depth) / 2))
  }
  | .board[0] = false
  | .board[$emptyStart] = false;

# Display the sequence of moves to a solution
def display($depth):
  init($depth; 1)
  | . as $init
  | drawBoard,
    " Original setup\n",
    (first(solve) as $solve
     | $init
     | foreach ($solve.solutions[]) as [$peg, $over, $source] (.;
           .board[$peg]  = true
         | .board[$over] = false
         | .board[$source] = false;
         drawBoard,
         "Peg \($source) jumped over peg \($over) to land on \($peg)\n" ) ) ;

display(6),
"\nTotal number of solutions for a board of height 5 is \(init(5; 1) | count(solve))"
