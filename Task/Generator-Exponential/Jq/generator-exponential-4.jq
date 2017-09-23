# Infrastructure:
def last(f): reduce f as $i (null; $i);

# emit the last value that satisfies condition, or null
def while(condition; next):
  def w: if condition then ., (next|w) else empty end;
  last(w);

# Powers of m1 that are not also powers of m2.
# filtered_next_power(m1;m2) produces [[i, i^m1], [j, j^m1]] where i^m1
# is not a power of m2 and j^m2 < i^m1
#
def filtered_next_power(m1; m2):
  if . then . else [[0,0],[0,0]] end
  | (.[0] | next_power(m1)) as $next1
  | (.[1] | while( .[1] <= $next1[1]; next_power(m2))) as $next2
  | if $next1[1] == $next2[1]
    then [$next1, $next2] | filtered_next_power(m1;m2)
    else [$next1, $next2]
    end ;

# Emit ten powers of 2 that are NOT powers of 3,
# skipping the first 20 integers satisfying the condition, including 0.
filtered_next_power(2;3)
  | skip(20; filtered_next_power(2;3))
  | emit(10; filtered_next_power(2;3))
  | .[0][1]
