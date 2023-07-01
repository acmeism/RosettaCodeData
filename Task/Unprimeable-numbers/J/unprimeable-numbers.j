NB. replace concatenates at various ranks and in boxes to avoid fill
NB. the curtailed prefixes (}:\) with all of 0..9 (i.10) with the beheaded suffixes (}.\.)
NB. under the antibase 10 representation (10&#.inv)
replace=: ([: ; <@}:\ ,"1 L:_1 ([: < (i.10) ,"0 1 }.)\.)&.(10&#.inv)

NB. primable tests if one of the replacements is prime
primable=: (1 e. 1 p: replace)&>

unprimable=: -.@:primable

assert 0 1 -: unprimable 193 200
