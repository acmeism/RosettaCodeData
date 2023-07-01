proc sample rng {foreach - {1 2 3 4 5} {lappend r [$rng rand]}; join $r ", "}
puts BSD:\t\[[sample [BSDRNG new 1]]\]
puts MS:\t\[[sample [MSRNG new 1]]\]
