def primes:
  2, (range(3;infinite;2) | select(is_prime));

def emit_until(cond; stream): label $out | stream | if cond then break $out else . end;

def special_primes:
  foreach primes as $p ({};
    .emit = null
    | if .p == null then .p = $p | .emit = .p
      else ($p - .p) as $g
      | if $g > .gap then .p = $p | .gap=$g | .emit = .p
        else .
        end
      end;
    select(.emit).emit);

# The task
# The following assumesg invocation with the -n option:
emit_until(. >= 1050; special_primes)
