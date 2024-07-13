### For the sake of gojq
# This def of transpose can be omitted if using the C implementation of jq.
# Rows are padded with nulls so the result is always rectangular.
def transpose: [range(0; map(length)|max // 0) as $i | [.[][$i]]];

###############################################################################
### Generic functions

def array($n): [range(0;$n) as $i | .];

def inform(msg):
  . as $in
  | ("\(msg)\n" | stderr)
  | $in;

def sum(stream): reduce stream as $x (0; . + $x);

def count(stream): sum(stream|1);

# null-based elementwise "or" for arrays
def or_array($b):
  . as $a
  | reduce range(0;length) as $i ([];
      . + [if $a[$i] == null then $b[$i] else $a[$i] end]);

# null-based elementwise "or" for matrices
def or_matrix($b):
  . as $a
  | reduce range(0;length) as $i ([];
      . + [$a[$i] | or_array($b[$i])] );

# Pretty-print the input, which must be an array but is normally a matrix.
# Notice that null nows and null values are handled specially.
def pp:
  .[]
  | if . == null then ""
    else
      reduce .[] as $x ("";
        . + if $x == 0 then " ."
            elif $x == null then "  "
            else " 1"
            end )
    end;


### Nonogram Solver

## Building blocks:

# $a and $b are normally arrays with $a | length <= $b | length
# Output: an array of the same length as $a, such that
# the element at $i is ( a[$i] == $b[$i] ? a[$i] : null )
def common($a; $b):
  [ range(0;$a|length) as $i
    | $a[$i]
    | if . == $b[$i] then . else null end ];

# If `stream` is a stream of arrays, the output will be the reduction
# of the stream based on common/2, except that the output is null if
# the arrays have no elements in common.
# The implementation is intended to serve as the complete specification.
# Notice in particular the "short-circuit" semantics, and
# that an occurrence of null or [] in the stream will produce `null`
def common(stream):
  def count: sum( .common[] | if . == null then 0 else 1 end );
  first(
    foreach (stream, null) as $x ({common: null, emit: 0};
      if $x == null then .emit = .common
      elif .common == null then .common = $x
      else .common |= common(.; $x)
      | if count == 0 then .emit=null end
      end)
    | select(.emit != 0).emit);

# $common should be null or an array.  If $common is null, any input
# is agreeable.  Otherwise, if the input is an array, then the output
# is true or false as the input is in point-wise agreement with
# $common in the sense that an occurrence of `null` in $common imposes
# no constraint on the corresponding item in the input.
# The implementation is intended to serve as the complete specification.
def agreeable($common):
  if $common == null then true
  else . as $in
  | all( range(0; $common|length);
         . as $i
         | if $common[$i] == null then true
           else $common[$i] == $in[$i]
           end)
  end;

# Convert an alphabetic specification of a sequence of runs
# to an array of integer arrays, e.g. "AB A" => [[1,2], [1]]
# Use _ for 0
def alphabet2runs:
  split(" ")
  | map( [explode[] | if . == 95 then 0 else . - 64 end]);

# A recursive helper function for runs2rows/2.
# Output: a stream of the rows with the required runs.
# Each row begins with a 0 for ensuring separation between the runs.
def genSequence($ones; $numZeros):
  if $ones|length == 0 then (0|array($numZeros))
  else range(1; $numZeros - ($ones|length) + 2) as $x
  | genSequence($ones[1:]; $numZeros - $x) as $tail
  | (0|array($x)) + $ones[0] + $tail
  end;

# $rows should be an array of integers specifying the run lengths in a row of length $len.
# Output: a stream of arrays of length $len with the specified runs
def runs2rows($runs; $len):
  ($runs|map(select(. != 0))) as $runs  # ignore 0s
  | if ($runs|length) == 1 and $runs[0] == $len then 1|array($len)
    else sum($runs[]) as $sum
    | if $len - $sum <= 0
      then empty
      else
        (reduce ($runs|map(select(. != 0)))[] as $run ([]; . + [1|array($run)] )) as $data
        | genSequence($data; $len - $sum + 1)[1:]
      end
    end;

# Check the acceptability of . based on $common
def acceptable($common):
  . as $in
  | $common == null
     or all( range(0;length); . as $i | $common[$i] | IN(null, $in[$i])) ;

# The rows that are acceptable w.r.t. $common
def runs2rows($runs; $len; $common):
  runs2rows($runs; $len)
  | select(acceptable($common));

# Setup {rows, cols, common} based on $rowruns and $colruns
def setup($rowruns; $colruns):
  ($rowruns | length) as $nrows
  | ($colruns | length) as $ncols

  | ($rowruns | map(common(runs2rows(.; $ncols)) ) ) as $commonRows

  | ($colruns | map(common(runs2rows(.; $nrows)) ) ) as $commonCols
  | ($commonCols | transpose | or_matrix($commonRows)) as $common
  | ($common | transpose) as $ct
  | { rows: [range(0; $nrows) as $i | [runs2rows($rowruns[$i]; $ncols; $common[$i]) ]],
      cols: [range(0; $ncols) as $i | [runs2rows($colruns[$i]; $nrows; $ct[$i]) ]],
      common: $common,
      matrix: [],
    };

# Winnow .rows and .cols based on point-wise commonality
def winnow:
  .reduction = 0
  | (.rows|length) as $nrows
  | (.cols|length) as $ncols
  # Winnow each row that has not already been fixed
  | reduce range(0; $nrows) as $i (.;
      if (.rows[$i] | length) != 1
      then common(.rows[$i][]) as $common
      | (.rows[$i] | length) as $before
      | .rows[$i] |= map(select(agreeable($common)))
      | .reduction += ((.rows[$i]|length) - $before)
      end )
  # Winnow each col that has not already been fixed
  | reduce range(0; $ncols) as $i (.;
      if (.cols[$i] | length) != 1
      then common(.cols[$i][]) as $common
      | (.cols[$i] | length) as $before
      | .cols[$i] |= map(select(agreeable($common)))
      | .reduction += ((.cols[$i]|length) - $before )
      end)
  | inform("reduction by \(.reduction)")
  | if .reduction != 0 then winnow end ;


# Input: {rows, cols}
# If setting .matrix[$i] to $row is feasible,
# then winnow .cols accordingly and finally set .matrix[$i] to $row
def set($i; $row):
  (.cols | length) as $ncols
  | .cols as $cols
  | if all(range(0; $ncols);
          . as $j
          | any( range(0; $cols[$j]|length);
                 $cols[$j][.][$i] == $row[$j] ) )
    then foreach range(0; $ncols) as $j (.;
      .cols[$j][] |= select( .[$i] == $row[$j] ) )
    else empty
    end
  | .matrix[$i] = $row;

# Input: {rows, cols, matrix} where .matrix is the candidate matrix constructed so far
# After all the columnwise- and rowwise-constraints have been examined...
def solve($colruns):
  (.rows|length) as $nrows
  | (.cols|length) as $ncols
  | (.matrix|length) as $m
  | if $m == $nrows
    then .
    else range(0; .rows[$m]|length) as $p
    | .rows[$m][$p] as $row
    | set($m; $row)
    | solve($colruns)
    end ;

# Generate all solutions
def generate( $rowruns; $colruns ):
  ($rowruns | length) as $nrows
  | ($colruns | length) as $ncols
  | setup( $rowruns; $colruns )
  | winnow
  | solve($colruns);

# Generate a single solution
# Top-level: $p should be an array of two alphabetic ([A-Z_]) strings representing
# the row-wise and columnwise run lengths, respectively,
# with _ signifying 0, A signifying 1, etc.
def generate($p):
    ($p[0] | alphabet2runs) as $rowruns
  | ($p[1] | alphabet2runs) as $colruns
  | first( generate($rowruns; $colruns ) ) ;

# Top-level convenience function, where p is a puzzle specification in alphabetic form.
def puzzle($title; p):
  $title,
  ( generate(p)
    | .matrix
    | pp ),
  "";

def p0: [ "B A A", "B A A"];

def p1:
  ["C BA CB BB F AE F A B", "AB CA AE GA E C D C"];

def p2: [
  "F CAC ACAC CN AAA AABB EBB EAA ECCC HCCC",
  "D D AE CD AE A DA BBB CC AAB BAA AAB DA AAB AAA BAB AAA CD BBA DA"
];

def p3: [
  "CA BDA ACC BD CCAC CBBAC BBBBB BAABAA ABAD AABB BBH " +
    "BBBD ABBAAA CCEA AACAAB BCACC ACBH DCH ADBE ADBB DBE ECE DAA DB CC",
  "BC CAC CBAB BDD CDBDE BEBDF ADCDFA DCCFB DBCFC ABDBA BBF AAF BADB DBF " +
    "AAAAD BDG CEF CBDB BBB FC"
];

def p4: [
  "E BCB BEA BH BEK AABAF ABAC BAA BFB OD JH BADCF Q Q R AN AAN EI H G",
  "E CB BAB AAA AAA AC BB ACC ACCA AGB AIA AJ AJ " +
    "ACE AH BAF CAG DAG FAH FJ GJ ADK ABK BL CM"
];

puzzle("p1"; p1),
puzzle("p2"; p2),
puzzle("p3"; p3),
puzzle("p4"; p4)
