use Lingua::EN::Numbers;

constant \C = 1, |[\×] (2, 6 … ∞) Z/ 2 .. *;

sub binomial { [×] ($^n … 0) Z/ 1 .. $^p }

my \𝐌 = 1, |(1..∞).map: -> \𝐧 { sum ^𝐧 .map( -> \𝐤 { C[𝐤] × binomial 𝐧, 2×𝐤 } ) };

say " 𝐧          𝐌[𝐧]            Prime?";
𝐌[^42].kv.map: { printf "%2d %24s  %s\n", $^k, $^v.&comma, $v.is-prime };
