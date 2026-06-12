use Base::Any;
use List::Divvy;

my @np = 4,6,8,9, |lazy (11..*).hyper.grep( -> $n { ($n.substr(*-1) eq '0') || (1 < [gcd] $n.comb».Int) || none (2..$n).map: { try "$n".&from-base($_).is-prime } } );

put "First 50 pan-base composites:\n" ~ @np[^50].batch(10)».fmt("%3s").join: "\n";
put "\nFirst 20 odd pan-base composites:\n" ~ @np.grep(* % 2)[^20].batch(10)».fmt("%3s").join: "\n";

my $threshold = 2500;
put "\nCount of pan-base composites up to and including $threshold: " ~ +@np.&upto($threshold);

put "Percent odd  up to and including $threshold: " ~ +@np.&upto($threshold).grep(* % 2) / +@np.&upto($threshold) × 100;
put "Percent even up to and including $threshold: " ~ +@np.&upto($threshold).grep(* %% 2) / +@np.&upto($threshold) × 100;
