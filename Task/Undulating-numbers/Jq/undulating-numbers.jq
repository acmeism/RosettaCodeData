## For the sake of gojq:
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

## Generic functions
def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def tobase($b):
  def digit: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[.:.+1];
  def mod: . % $b;
  def div: ((. - mod) / $b);
  def digits: recurse( select(. > 0) | div) | mod ;
  # For jq it would be wise to protect against `infinite` as input, but using `isinfinite` confuses gojq
  select( (tostring|test("^[0-9]+$")) and 2 <= $b and $b <= 36)
  | if . == 0 then "0"
    else [digits | digit] | reverse[1:] | add
    end;

# tabular print
def tprint(columns; wide):
  reduce _nwise(columns) as $row ("";
     . + ($row|map(lpad(wide)) | join(" ")) + "\n" );

def is_prime:
  . as $n
  | if ($n < 2)         then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    elif ($n % 5 == 0)  then $n == 5
    elif ($n % 7 == 0)  then $n == 7
    elif ($n % 11 == 0) then $n == 11
    elif ($n % 13 == 0) then $n == 13
    elif ($n % 17 == 0) then $n == 17
    elif ($n % 19 == 0) then $n == 19
    else sqrt as $s
    | 23
    | until( . > $s or ($n % . == 0); . + 2)
    | . > $s
    end;

## Undulating numbers
def undulating($base; $n):
  53 as $mpow
  | (pow(2;$mpow) - 1) as $limit
  | ($base * $base) as $bsquare
  | { u3: [], u4: [] }
  | reduce range(1; $base) as $a (.;
       reduce range(0; $base) as $b (.;
            if $b == $a then .
            else ($a * $bsquare + $b * $base + $a) as $u
            | .u3 += [$u]
            | ($a * $base + $b) as $v
            | .u4 += [$v * $bsquare + $v]
            end) )
  | "All 3-digit undulating numbers in base \($base):",
     (.u3 | tprint(9; 4)),
     "All 4-digit undulating numbers in base \($base):",
     (.u4 | tprint(9; 5)),
     "All 3-digit undulating numbers which are primes in base \($base):",
     ( .primes = []
      | reduce .u3[] as $u (.;
          if $u % 2 == 1 and $u % 5 != 0 and ($u | is_prime)
          then .primes += [$u]
          else .
          end)
      | (.primes | tprint(10; 4))),
     ( .un = (.u3 + .u4)
      | (.un|length) as $unc
      | .j = 0
      | .i = 0
      | .done = false
      | until(.done;
          .i = 0
          | until(.i >= $unc;
              (.un[.j * $unc + .i] * $bsquare + (.un[.j * $unc + .i] % $bsquare)) as $u
              | if $u > $limit then .done = true | .i = $unc
                else .un += [$u]
                | .i += 1
		        end )
          | .j += 1 )
       | "\nThe \($n)th undulating number in base \($base) is: \(.un[$n-1])",
         (select($base != 10) | "or expressed in base \($base): \(.un[$n-1] | tobase($base))"),
         "\nTotal number of undulating numbers in base \($base) < 2^\($mpow) = \(.un|length)",
         "of which the largest is: \(.un[-1])",
         (select($base != 10) | "or expressed in base \($base): \(.un[-1]| tobase($base))")
       ) ;

(10, 7) as $base
| undulating($base; 600), ""
