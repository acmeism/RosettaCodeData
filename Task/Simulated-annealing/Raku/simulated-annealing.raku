# simulation setup
my \cities = 100;  # number of cities
my \kmax   = 1e6;  # iterations to run
my \kT     = 1;    # initial 'temperature'

die 'City count must be a perfect square.' if cities.sqrt != cities.sqrt.Int;

# locations of (up to) 8 neighbors, with grid size derived from number of cities
my \gs = cities.sqrt;
my \neighbors = [1, -1, gs, -gs, gs-1, gs+1, -(gs+1), -(gs-1)];

# matrix of distances between cities
my \D = [;];
for 0 ..^ cities² -> \j {
    my (\ab, \cd)       = (j/cities, j%cities)».Int;
    my (\a, \b, \c, \d) = (ab/gs, ab%gs, cd/gs, cd%gs)».Int;
    D[ab;cd] = sqrt (a - c)² + (b - d)²
}

sub T(\k, \kmax, \kT)      { (1 - k/kmax) × kT }                                 # temperature function, decreases to 0
sub P(\ΔE, \k, \kmax, \kT) { exp( -ΔE / T(k, kmax, kT)) }                        # probability to move from s to s_next
sub Es(\path)              { sum (D[ path[$_]; path[$_+1] ] for 0 ..^ +path-1) } # energy at s, to be minimized

# variation of E, from state s to state s_next
sub delta-E(\s, \u, \v) {
    my (\a,   \b,  \c,  \d) = D[s[u-1];s[u]], D[s[u+1];s[u]], D[s[v-1];s[v]], D[s[v+1];s[v]];
    my (\na, \nb, \nc, \nd) = D[s[u-1];s[v]], D[s[u+1];s[v]], D[s[v-1];s[u]], D[s[v+1];s[u]];
    if    v == u+1 { return (na + nd) - (a + d) }
    elsif u == v+1 { return (nc + nb) - (c + b) }
    else           { return (na + nb + nc + nd) - (a + b + c + d) }
}

# E(s0), initial state
my \s = @ = flat 0, (1 ..^ cities).pick(*), 0;
my \E-min-global = my \E-min = $ = Es(s);

for 0 ..^ kmax -> \k {
    printf "k:%8u  T:%4.1f  Es: %3.1f\n" , k, T(k, kmax, kT), Es(s)
            if k % (kmax/10) == 0;

    # valid candidate cities (exist, adjacent)
    my \cv = neighbors[(^8).roll] + s[ my \u = 1 + (^(cities-1)).roll ];
    next if cv ≤ 0 or cv ≥ cities or D[s[u];cv] > sqrt(2);

    my \v  = s[cv];
    my \ΔE = delta-E(s, u, v);
    if ΔE < 0 or P(ΔE, k, kmax, kT) ≥ rand { # always move if negative
        (s[u], s[v]) = (s[v], s[u]);
        E-min += ΔE;
        E-min-global = E-min if E-min < E-min-global;
    }
}

say "\nE(s_final): " ~ E-min-global.fmt('%.1f');
say "Path:\n" ~ s».fmt('%2d').rotor(20,:partial).join: "\n";
