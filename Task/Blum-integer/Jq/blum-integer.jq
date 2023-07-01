### Generic utilities
def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# tabular print
def tprint(columns; wide):
  reduce _nwise(columns) as $row ("";
     . + ($row|map(lpad(wide)) | join(" ")) + "\n" );

### Primes
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

def primes: 2, (range(3;infinite;2) | select(is_prime));

# input: the number to be tested
def isprime($smalls):
  if . < 2 then false
  else sqrt as $s
  | (first( $smalls[] as $p
            | if . == $p then 1
              elif . % $p == 0 then 0
              elif $p > $s then 1
              else empty
              end) // null) as $result
    | if $result then $result == 1
      else ($smalls[-1] + 2)
      | until( . > $s or ($n % . == 0); . + 2)
      | . > $s
      end
    end;

# Assumes n is odd.
def firstPrimeFactor:
  if (. == 1) then 1
  elif (. % 3 == 0) then 3
  elif (. % 5 == 0) then 5
  else  . as $n
  | [4, 2, 4, 2, 4, 6, 2, 6] as $inc
  | { k: 7,
      i: 0 }
  | ($n | sqrt) as $s
  | until (.k > $s or .done;
        if $n % .k == 0
        then .done = true
        else .k += $inc[.i]
        | .i = (.i + 1) % 8
        end )
  | if .done then .k else $n end
  end ;

### Blum integers

# Number of small primes to pre-compute
def task($numberOfSmallPrimes):
  [limit($numberOfSmallPrimes; primes)] as $smalls
  | { blum: [],
      bc:0,
      counts: { "1": 0, "3": 0, "7": 0, "9": 0 },
      i: 1 }
  | label $out
  | foreach range(0; infinite) as $_ (.;
      (.i|firstPrimeFactor) as $p
      | .j = null
      | if ($p % 4 == 3)
        then (.i / $p) as $q
        | if $q != $p and ($q % 4 == 3) and ($q | isprime($smalls))
          then if (.bc < 50) then .blum[.bc] = .i else . end
          | .counts[(.i % 10) | tostring] += 1
          | .bc += 1
  	  | .j = .i
          else .
	  end
	else .
	end
    | .i |= if (. % 5 == 3) then . + 4 else . + 2 end;

    select(.j)
    | if (.bc == 50)
      then "First 50 Blum integers:",
           (.blum | tprint(10; 3) )
      elif .bc == 26828 or .bc % 1e5 == 0
      then "The \(.bc) Blum integer is: \(.j)",
           if .bc == 400000
           then "\n% distribution of the first 400,000 Blum integers:",
                 ((.counts|keys_unsorted[]) as $k
                  | "  \( .counts[$k] / 4000 )% end in \($k)"),
           break $out
           else empty
           end
      else empty
      end);

task(10000)
