use Lingua::EN::Numbers:ver<2.8+>;

my @magic-constants = lazy (3..∞).hyper.map: { (1 + .²) * $_ / 2 };

put "First 20 magic constants: ", @magic-constants[^20]».&comma;
say "1000th magic constant: ", @magic-constants[999].&comma;
say "\nSmallest order magic square with a constant greater than:";

(1..20).map: -> $p {printf "10%-2s: %s\n", $p.&super, comma 3 + @magic-constants.first( * > exp($p, 10), :k ) }
