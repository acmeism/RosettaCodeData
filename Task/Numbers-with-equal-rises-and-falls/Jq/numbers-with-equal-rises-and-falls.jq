def risesEqualsFalls:
  . as $n
  | if . < 10 then true
    else {rises: 0, falls: 0, prev: -1, n: $n}
    | until (.n <= 0;
        (.n % 10 ) as $d
        | if .prev >= 0
          then if $d < .prev then .rises += 1
               elif $d > .prev then .falls += 1
               else .
	       end
	  else .
	  end
        | .prev = $d
        | .n = ((.n/10)|floor) )
    | .rises == .falls
    end ;

def A296712: range(1; infinite) | select(risesEqualsFalls);

# Override jq's incorrect definition of nth/2
# Emit the $n-th value of the stream, counting from 0; or emit nothing
def nth($n; s):
 if $n < 0 then error("nth/2 doesn't support negative indices")
 else label $out
 | foreach s as $x (-1; .+1; select(. >= $n) | $x, break $out)
 end;

# The tasks
"First 200:",
 [limit(200; A296712)],

 "\nThe 10 millionth number in the sequence is \(
    nth(1e7 - 1; A296712))"
