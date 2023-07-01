def ismagnanimous:
  . as $n
  | if $n < 10 then true
    else first(range( 1; tostring|length) as $i
	       | divrem($n; (10|power($i))) as [$q, $r]
               | if ($q + $r) | is_prime == false then 0 else empty end)
         // true
    | . == true
    end;

# An unbounded stream ...
def magnanimous:
  range(0; infinite)
  | select(ismagnanimous);

[limit(400; magnanimous)]
| "First 45 magnanimous numbers:", .[:45],
  "\n241st through 250th magnanimous numbers:", .[241:251],
  "\n391st through 400th magnanimous numbers:", .[391:]
