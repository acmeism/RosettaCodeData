def is_brilliant:
  . as $in
  | sqrt as $sqrt

  | def is_prime:
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
      else 23
           | until( . > $sqrt or ($n % . == 0); .+2)
  	 | . * . > $n
      end;

  {i: 2, n: .}
  | until( (.i > $sqrt) or .result;
      if .n % .i == 0
      then .n /= .i
      | if (.i|tostring|length) == (.n|tostring|length)
        # notice there is no need to check that .i is prime
        and (.n | is_prime)
        then .result = 1
	else .result = 0
        end
      else .i += 1
      end)
  | .result == 1;

# Output a stream of brilliant numbers
def brilliants:
  4,6,9,10,14, (range(15;infinite;2) | select(is_brilliant));

def monitor(generator; $power):
    pow(10; $power) as $power
    | label $out
    | foreach generator as $x ({n: 0, p: -1, watch: 1};
        .n += 1
        | if $x >= .watch
          then .emit = true
          | .watch *= 10 | .p += 1
          | if .watch >= $power then ., break $out else . end
          else .emit = null
          end;
        select(.emit) | [.p, .n, $x]) ;

"The first 100 brilliant numbers:",
[limit(100;  brilliants)],
"\n[power of 10, index, brilliant]",
monitor(brilliants; 7)
