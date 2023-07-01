use Lingua::EN::Numbers;

my \𝐌 = 1, 1, { state $i = 2; ++$i; ($^b × (2 × $i - 1) + $^a × (3 × $i - 6)) ÷ ($i + 1) } … *;

say " 𝐧          𝐌[𝐧]            Prime?";
𝐌[^42].kv.map: { printf "%2d %24s  %s\n", $^k, $^v.&comma, $v.is-prime };
