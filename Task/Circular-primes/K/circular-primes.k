pm: { /print matrix
    fw: -(3 + _log10e * 1e-12 + |/`ln x)
    `0: (,/fw$$)'(0N;y) # x}

pr: {$[x < 5; |/ x = 2 3; &/ ~0=(`pri (`i$ 1 + %x))!' x]}

log10e: 1%`ln 10
len: {1+_1e-12+log10e*`ln x}
rot: {10/ {(1_x), *x} (10\x)}
rots: {(-1 + len x) rot\ x}
circ: {r: rots x; $[&/~(*r) > 1_r; &/pr' r; 0]}

gen: {[n] {{y+10*x}/x}' (1 3 7 9)@+!n#4}
cand: ,/gen' 2+!5

ps: 2, 3, 5, 7, cand@&circ' cand

`0: "The circular primes are:"
pm[ps; 10]
