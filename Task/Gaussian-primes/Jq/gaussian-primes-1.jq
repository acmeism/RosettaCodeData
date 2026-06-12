### Complex numbers

# For clarity:
def real: first;
def imag: last;

# Complex or real
def norm:
  def sq: .*.;
  if type == "number" then sq
  else map(sq) | add
  end;

# Complex or real
def abs:
  if type == "array" then norm | sqrt
  elif . < 0 then - . else .
  end;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Input should be an integer
def isPrime:
  . as $n
  | if ($n < 2)         then false
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

# Given a stream of non-null values,
# group by the values of `x|filter` that occur in a run.
def runs(stream; filter):
  foreach (stream, null) as $x ({emit: false, array: []};
    if $x == null
    then .emit = .array
    elif .array == [] or ($x|filter) == (.array[0]|filter)
    then .array += [$x] | .emit = false
    else {emit: .array, array: [$x]}
    end;
    select(.emit).emit)  ;
