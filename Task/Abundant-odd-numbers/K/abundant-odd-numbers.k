divs: {
    r: _%x;
    lower: 1 + &0 = (1 + !r)!' x;
    upper: ({(-y)!x}[x;])' lower;
    lower, (x = r*r)_|upper}

proper: {(-x) +/ divs x}
abundant: {x < proper x}

kap: 250000 /number of candidates to test; tweak until result is above 1k

n: 1+2*!kap
a: n[&abundant' n]

`0: "The first 25 abundant odd numbers:"
nulls: {`0: ($x), "; proper sum: ", $proper x}' 25#a
`0: "The 1000th: ", ($a[999]), "; proper sum: ", $proper a[999]

big: {~abundant x} {x+2}/ 1000000001
`0: "The first > 1e9: ", ($big), "; proper sum: ", $proper big
