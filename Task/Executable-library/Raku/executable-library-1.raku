module Hailstone {
    our sub hailstone($n) is export {
	$n, { $_ %% 2 ?? $_ div 2 !! $_ * 3 + 1 } ... 1
    }
}

sub MAIN {
    say "hailstone(27) = {.[^4]} [...] {.[*-4 .. *-1]}" given Hailstone::hailstone 27;
}
