constant ltp = [2, 3, 5, 7], {
    last if .not;
    [ ((1..9) X~ @$_).grep: &is-prime ]
} ... *;

constant rtp = [2, 3, 5, 7], {
    last if .not;
    [ (@$_ X~ (1,3,7,9)).grep: &is-prime ]
} ... *;

say "Largest ltp < 1e6 = ", ltp[5][*-1];
say "Largest rtp < 1e6 = ", rtp[5][*-1];
say "Largest possible ltp = ", ltp.eager.flat.tail;
say "Largest possible rtp = ", rtp.eager.flat.tail;
