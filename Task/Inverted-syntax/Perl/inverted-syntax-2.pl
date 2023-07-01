# Note that the results obtained by the inverted syntax form
# may produce differing results from the traditional syntax form
$a = $ok ? $b : $c;     # Traditional syntax
($ok ? $b : $c) = $a;   # Inverted syntax
