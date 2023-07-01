# emit a stream of gapful numbers greater than or equal to $start,
# which is assumed to be an integer
def gapful($start):
    range($start; infinite)
    | . as $i
    | tostring as $s
    | (($s[:1] + $s[-1:]) | tonumber) as $x
    | select($i % $x == 0);

"First 30 gapful numbersstarting from 100:",
([limit(30;gapful(100))] | join(" ")),
"First 15 gapful numbers starting from 1,000,000:",
([limit(15;gapful(1000000))] | join(" ")),
"First 10 gapful numbers starting from 10^9:",
([limit(10;gapful(pow(10;9)))] | join(" "))
