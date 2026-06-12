### Preliminaries

def count(s): reduce s as $x (null; .+1);

def emit_until(cond; stream):
  label $out | stream | if cond then break $out else . end;

# Output: an unbounded stream
def primes_with_exactly_one_odd_digit:
  # Output: a stream of candidate strings, in ascending numerical order
  def candidates:
    # input is $width
    def evens:
      . as $width
      | if $width == 0 then ""
        else ("0","2","4","6","8") as $i
        | ((.-1)|evens) as $j
        | "\($i)\($j)"
        end;
    ("2","4","6","8") as $leading
    | evens as $even
    | ("1","3","5","7","9") as $odd
    | "\($leading)\($even)\($odd)";

  (3,5,7),
  (range(0; infinite)
   | candidates | tonumber
   | select(is_prime)) ;

### The Task
emit_until(. > 1000; primes_with_exactly_one_odd_digit),

"\nThe number of primes less than 1000000 with exactly one odd digits is \(count(emit_until(. > 1000000; primes_with_exactly_one_odd_digit)))."
