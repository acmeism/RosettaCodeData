log10 =: 10&^.
benford =: log10@:(1+%)
assert '0.30 0.18 0.12 0.10 0.08 0.07 0.06 0.05 0.05' -: 5j2 ": benford >: i. 9


append_next_fib =: , +/@:(_2&{.)
assert 5 8 13 -: append_next_fib 5 8

leading_digits =: {.@":&>
assert '581' -: leading_digits 5 8 13x

count =: #/.~ /: ~.
assert 2 1 3 4 -: count 'XCXBAXACXC'  NB. 2 A's, 1 B, 3 C's, and some X's.

normalize =: % +/
assert 1r3 2r3 -: normalize 1 2x

FIB =: append_next_fib ^: (1000-#) 1 1
LDF =: leading_digits FIB


TALLY_BY_KEY =: count LDF
assert 9 -: # TALLY_BY_KEY   NB. If all of [1-9] are present then we know what the digits are.

mean =: +/ % #
center=: - mean
mp =: $:~ :(+/ .*)
num =: mp&:center
den =: %:@:(*&:(+/@:(*:@:center)))
r =: num % den   NB. r is the LibreOffice correl function
assert '_0.982' -: 6j3 ": 1 2 3 r 6 5 3  NB. confirmed using LibreOffice correl function


assert '0.9999' -: 6j4 ": (normalize TALLY_BY_KEY) r benford >: i.9

assert '0.9999' -: 6j4 ": TALLY_BY_KEY r benford >: i.9  NB. Of course we don't need normalization
