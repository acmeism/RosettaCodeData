#| an array of four words, that have more possible values.
#| Normally we would want `any' to signify we want any of the values, but well negate later and thus we need `all'
my @a =
(all «the that a»),
(all «frog elephant thing»),
(all «walked treaded grows»),
(all «slowly quickly»);

sub test (Str $l, Str $r) {
    $l.ends-with($r.substr(0,1))
}

(sub ($w1, $w2, $w3, $w4){
  # return if the values are false
  return unless [and] test($w1, $w2), test($w2, $w3),test($w3, $w4);
  # say the results. If there is one more Container layer around them this doesn't work, this is why we need the arguments here.
  say "$w1 $w2 $w3 $w4"
})(|@a); # supply the array as argumetns
