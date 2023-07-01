constant expansions = [1], [1,-1], -> @prior { [|@prior,0 Z- 0,|@prior] } ... *;

sub polyprime($p where 2..*) { so expansions[$p].[1 ..^ */2].all %% $p }

# Showing the expansions:

say ' p: (x-1)ᵖ';
say '-----------';

sub super ($n) {
    $n.trans: '0123456789'
           => '⁰¹²³⁴⁵⁶⁷⁸⁹';
}

for ^13 -> $d {
    say $d.fmt('%2i: '), (
        expansions[$d].kv.map: -> $i, $n {
            my $p = $d - $i;
            [~] gather {
                take < + - >[$n < 0] ~ ' ' unless $p == $d;
                take $n.abs                unless $p == $d > 0;
                take 'x'                   if $p > 0;
                take super $p - $i         if $p > 1;
            }
        }
    )
}

#  And testing the function:

print "\nPrimes up to 100:\n  { grep &polyprime, 2..100 }\n";
