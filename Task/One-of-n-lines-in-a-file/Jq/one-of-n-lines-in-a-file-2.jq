# oneOfN presupposes an unbounded stream
# of 4-digit PRNs uniformly distributed on [0-9999]
def oneOfN:
  reduce range(2; 1+.) as $i (1;
    if (input / 10000) < (1/$i) then $i else . end);

def n: 10;
def repetitions: 1e6;

( reduce range(0; repetitions) as $i (null;
    (n|oneOfN) as $num
    | .[$num-1] += 1 )) as $freqs
|  range(1; 1+n) | "Line\(.) \($freqs[.-1] )"
