# The following may be omitted if using the C implementation of jq
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

### Generic functions
def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# tabular print
def tprint($columns; $width):
  reduce _nwise($columns) as $row ("";
     . + ($row|map(lpad($width)) | join(" ")) + "\n" );

# like while/2 but emit the final term rather than the first one
def whilst(cond; update):
     def _whilst:
         if cond then update | (., _whilst) else empty end;
     _whilst;

## Prime factors

# Emit an array of the prime factors of 'n' in order using a wheel with basis [2, 3, 5]
# e.g. 44 | primeFactors => [2,2,11]
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

### Cube-free numbers
# If cubefree then emit the largest prime factor, else emit null
def cubefree:
  if . % 8 == 0 or . % 27 == 0 then false
  else  primeFactors as $factors
  | ($factors|length) as $n
  | {i: 2, cubeFree: true}
  | until (.cubeFree == false or .i >= $n;
      $factors[.i-2] as $f
      | if $f == $factors[.i-1] and $f == $factors[.i]
        then .cubeFree = false
        else .i += 1
        end)
  | if .cubeFree then $factors[-1] else null end
  end;

## The tasks
  { res:    [1],  # by convention
    count:    1,  # see the previous line
    i:        2,
    lim1:   100,
    lim2:  1000,
     max: 10000 }
  | whilst (.count <= .max;
      .emit = null
      | (.i|cubefree) as $result
      | if $result
        then .count += 1
        | if .count <= .lim1 then .res += [$result] end
        | if .count == .lim1
          then .emit = ["First \(.lim1) terms of a[n]:"]
          | .emit += [.res | tprint(10; 3)]
          elif .count == .lim2
          then .lim2 *= 10
          | .emit = ["The \(.count) term of a[n] is \($result)"]
          end
        end
      | .i += 1
      | if .i % 8 == 0 or .i % 27 == 0
        then .i += 1
        end
    )
  | select(.emit) | .emit[]
