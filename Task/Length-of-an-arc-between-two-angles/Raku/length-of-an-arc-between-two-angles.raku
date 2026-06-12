sub arc ( Real \a1, Real \a2, :r(:$radius) = 1 ) {
    ( ([-] (a2, a1).map((* + τ) % τ)) + τ ) % τ × $radius
}

sub postfix:<°> (\d) { d × τ / 360 }
sub postfix:<ᵍ> (\g) { g × τ / 400 }

say 'Task example: from 120° counter-clockwise to 10° with 10 unit radius';
say arc(:10radius, 120°, 10°), ' engineering units';

say "\nSome test examples:";
for \(120°, 10°), # radian magnitude (unit radius)
    \(10°, 120°), # radian magnitude (unit radius)
    \(:radius(10/π), 180°, -90°), # 20 unit circumference for ease of comparison
    \(0°, -90°, :r(10/π),),       #  ↓  ↓  ↓  ↓  ↓  ↓  ↓
    \(:radius(10/π), 0°, 90°),
    \(π/4, 7*π/4, :r(10/π)),
    \(175ᵍ, -45ᵍ, :r(10/π)) {  # test gradian parameters
    printf "Arc length: %8s  Parameters: %s\n", arc(|$_).round(.000001), $_.raku
}
