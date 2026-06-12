### Generic functions

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# Emit an array of the prime factors of 'n' in order using a wheel with basis [2, 3, 5]
# e.g. 44 | primeFactors => [2,2,11]
# From https://rosettacode.org/wiki/Product_of_min_and_max_prime_factors#jq
def primeFactors:
  def out($i): until (.n % $i != 0; .factors += [$i] | .n = ((.n/$i)|floor) );
  if . < 2 then []
  else [4, 2, 4, 2, 4, 6, 2, 6] as $inc
    | { n: .,
        factors: [] }
    | out(2)
    | out(3)
    | out(5)
    | .k = 7
    | .i = 0
    | until(.k * .k > .n;
        if .n % .k == 0
        then .factors += [.k]
        | .n = ((.n/.k)|floor)
        else .k += $inc[.i]
        | .i = ((.i + 1) % 8)
        end)
    | if .n > 1 then .factors += [ .n ] else . end
  | .factors
  end;

# Define the helper function to take advantage of jq's tail-recursion optimization
def lcm($m; $n):
  def _lcm:
    # state is [m, n, i]
    if (.[2] % .[1]) == 0 then .[2] else (.[0:2] + [.[2] + $m]) | _lcm end;
  [$m, $n, $m] | _lcm;

def lcm(stream):
  reduce stream as $s (1; lcm(.; $s));

### Carmichael Lambda Function

def primePows:
  . as $n
  | { factPows: [] }
  | ($n | primeFactors) as $pf
  | .currFact = $pf[0]
  | .count = 1
  | reduce $pf[1:][] as $fact (.;
      if $fact != .currFact
      then .factPows += [[.currFact, .count]]
      | .currFact = $fact
      | .count = 1
      else .count += 1
      end)
  | .factPows + [[.currFact, .count]] ;

def phi($p; $r):
  ($p | power($r-1)) * ($p - 1);

# Initial cache values
def cache: [0, 1, 1, null, 2];   # [_, 1, phi(2; 1), _, phi(2; 2)]

# input: {cache}
# output: {cache, result}
def CarmichaelHelper($p; $r):
  ($p|power($r)) as $n
  | .cache[$n] as $cached
  | if $cached then .result=$cached
    else
      if $p > 2
      then .cache[$n] = phi($p; $r)
      else .cache[$n] = phi($p; $r - 1)
      end
      | .result = .cache[$n]
    end;

# input: {cache}
# output: {cache, result, a}
def CarmichaelLambda($n):
  .cache |= (. // cache)
  | .result = null
  | if $n < 1 then "CarmichaelLambda: argument must be a positive integer (vs\($n))" | error
    else
      if .cache[$n] then .result = .cache[$n]
      else ($n|primePows) as $pps
      | if ($pps|length) == 1
        then $pps[0][0] as $p
        | $pps[0][1] as $r
        | if $p > 2 then .cache[$n] = phi($p; $r)
          else .cache[$n] = phi($p; $r - 1)
          end
          | .result = .cache[$n]
        else .a = []
        | reduce $pps[] as $pp (.;
            CarmichaelHelper($pp[0]; $pp[1])
            | .a += [ .result ] )
        | .cache[$n] = lcm(.a[])
        | .result = .cache[$n]
        end
      end
    end ;

# input: {cache}
# output: {cache, result}
def iteratedToOne($j):
  {global: .,
   k: 0,
   $j}
  | until( .j <= 1;
        .j as $j
        | .global |= CarmichaelLambda($j)
        | .j = .global.result
        | .k +=  1 )
  | .global.result = .k
  | .global;

def task1($m):
  " n   λ   k",
  "----------",
  (foreach range(1; 1+$m) as $n ({};
     CarmichaelLambda($n)
     | .result as $lambda
     | iteratedToOne($n)
     | .result as $k
     | .emit = "\($n|lpad(2)) \($lambda|lpad(2)) \($k|lpad(2))" )
   | .emit ) ;

def task2($maxI; $maxN):
  "\nIterations to 1       i     lambda(i)",
  "=====================================",
  "   0                  1            1",
 ( . // {}
  | .cache |= (. // cache)
  | .found = [true, (range(0; $maxN)|false)]
  | .i=1
  | .n=null
  | while (.i <= $maxI and .n != $maxN;
      .emit = null
      | iteratedToOne(.i)
      | .n = .result
      | if (.found[.n]|not)
        then .found[.n] = true
        | CarmichaelLambda(.i)
        | .result as $lambda
        | .emit = "\(.n|lpad(4)) \(.i|lpad(18)) \($lambda|lpad(12))"
        end
      | .i += 1 )
  | select(.emit).emit );

task1(25),
"",
task2(5*1e6; 15)
