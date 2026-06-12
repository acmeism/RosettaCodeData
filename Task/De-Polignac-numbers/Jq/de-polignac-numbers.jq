# Input should be an integer
def isPrime:
  . as $n
  | if    ($n < 2)      then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    else 5
    | until( . <= 0;
        if .*. > $n then -1
	elif ($n % . == 0) then 0
        else . + 2
        |  if ($n % . == 0) then 0
           else . + 4
           end
        end)
     | . == -1
     end;

# Generate the stream of de Polignac integers:
def dePolignacs:
  1,
  ( range(3; infinite; 2) as $n
    | first(
        foreach range(0; infinite) as $i (null;
        if . == null then 1 else .*2 end;
        if . > $n then $n
        elif ($n - .) | isPrime
        then -1
        else empty
        end) )
    | select(.>0) ) ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task($n):
  (label $out
   | foreach dePolignacs as $i ({};
       .count += 1
       | if .count <= 50
         then .dp += [$i]
         elif .count == 1000
         then .dp1000 = $i
         elif .count == 10000
         then .dp10000 = $i
         else .
         end;
	   if .count == 10000 then ., break $out else empty end))
   | "The first \($n) de Polignac numbers:",
     (.dp | _nwise(10) | map(lpad(4)) | join(" ")),
     "\nThe  1,000th: \(.dp1000)",
     "\nThe 10,000th: \(.dp10000)";

task(50)
