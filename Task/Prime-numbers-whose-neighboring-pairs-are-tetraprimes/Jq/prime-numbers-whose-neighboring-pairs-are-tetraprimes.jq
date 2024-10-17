# The following may be omitted if using the C implementation of jq
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

### Generic functions

# Input is assumed to be an integer.
# Use a wheel with basis [2, 3, 5]
def is_prime:
  if . < 2 then false
  else . as $n
  | if   ($n % 2 == 0) then $n == 2
    elif ($n % 3 == 0) then $n == 3
    elif ($n % 5 == 0) then $n == 5
    else [4, 2, 4, 2, 4, 6, 2, 6] as $inc
    | { n: ., k: 7 }
    | .i = 0
    | first(
        while(.k * .k <= .n;
          if .n % .k == 0
          then .emit = 0
          else .k += $inc[.i]
          | .emit = null
          | .i = ((.i + 1) % 8)
          end)
        | (select(.emit) )) // true
    | . == true
    end
  end;

def inform(msg):
  (msg + "\n" | stderr | empty), .;

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# tabular print
def tprint($columns; $width):
  reduce _nwise($columns) as $row ("";
     . + ($row|map(lpad($width)) | join(" ")) + "\n" );

# It is assumed the input is sorted
def median:
  (length/2) as $l2
  | if $l2 == 0 then null
    elif length % 2 == 0
    then ($l2 | floor) as $m | (.[$m-1] + .[$m])/2
    else .[$l2]
    end;

# . is assumed to be sorted
# Output: the index of $x in . or else the insertion point
def nearest($x):
  bsearch($x) as $ix
  | if $ix >= 0 then $ix
    else -($ix+1)
    end;

### Tetraprimes

# Input: a sufficiently large array of primes
def isTetraPrime($n):
  def sq: .*.;
  . as $primes
  | { $n,
      count: 0,
      prevFactor: 1 }
  | label $out
  | foreach $primes[] as $p (.;
      .emit = null
      | ($p | sq) as $p2
      | (if   .count == 0 then $p2 | sq
         elif .count == 1 then $p2*$p
         else $p2 end) as $limit
      | if $limit <= .n
        then until(.emit or .n % $p != 0;
               if (.count == 4 or $p == .prevFactor)
               then .emit=0, break $out
               else .count += 1
               | .n |= ((./$p)|floor)
               | .prevFactor = $p
               end)
        else .emit = 1, break $out
        end)
  | select(.emit)
  | if .emit == 0 then false
    else if .n > 1
         then if .count == 4 or .n == .prevFact then false
              else .count += 1
              | .count == 4
              end
         else .count == 4
         end
    end ;

### The task

# $n determines the number of primes to examine, normally 1e5 1e6 or 1e7
def task($n):
  def p($k): reduce range(0;$k) as $_ (1; .*10);
  def highest($k):
     p($k) as $p
     | if $n >= $p then .[nearest($p) - 1] else null end;

  [range(0;$n) | select(is_prime)]
  | . as $primes
  | highest(5) as $highest5
  | highest(6) as $highest6
  | highest(7) as $highest7
  | { tetras1: [],
      tetras2: [],
      sevens1:  0,
      sevens2:  0,
      j:   100000
   }
  | foreach $primes[] as $p (.;
      # process even numbers first as likely to have most factors
      if ($primes|isTetraPrime($p-1)) and ($primes|isTetraPrime($p-2))
      then .tetras1 += [$p]
      | if (($p-1)%7 == 0 or ($p-2)%7 == 0) then .sevens1 += 1 end
      end

      | if ($primes | isTetraPrime($p+1)) and ($primes|isTetraPrime($p+2))
        then .tetras2 += [$p]
        | if (($p+1)%7 == 0 or ($p+2)%7 == 0) then .sevens2 += 1 end
        end
      # Reporting ...
      | if $p | IN($highest5, $highest6, $highest7)
        then foreach (0,1) as $i (.;
              (if ($i == 0) then .tetras1 else .tetras2 end) as $tetras
            | (if ($i == 0) then .sevens1 else .sevens2 end) as $sevens
            | ($tetras|length) as $c
            | (if ($i == 0) then "preceding" else "following" end) as $t
            | inform("Found \($c) primes under \(.j) whose \($t) neighboring pair are tetraprimes:")
            | if ($p == $highest5)
              then inform($tetras|tprint(10;5))
              end
            | inform("of which \($sevens) have a neighboring pair one of whose factors is 7.\n")
            | ([range(0; $c-1) | $tetras[.+1] - $tetras[.]] | sort) as $gaps
            | inform("Minimum gap between those \($c) primes : \($gaps[0])")
            | inform("Median  gap between those \($c) primes : \($gaps|median)")
            | inform("Maximum gap between those \($c) primes : \($gaps[-1])\n")
            )
         | .j *= 10
         end
      )
      | empty
;

task(1000000)
