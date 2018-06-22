.&ws.say for slurp.comb.Bag.sort: -*.value;

sub ws ($pair) {
    $pair.key ~~ /\n/
    ?? ('NEW LINE' => $pair.value)
    !! $pair.key ~~ /\s/
    ?? ($pair.key.uniname => $pair.value)
    !! $pair
}
