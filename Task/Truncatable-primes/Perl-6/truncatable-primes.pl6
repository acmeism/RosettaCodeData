constant ltp = [2, 3, 5, 7], -> @ltp {
    [ grep &is-prime, ((1..9) X~ @ltp) ]
} ... *;

constant rtp = [2, 3, 5, 7], -> @rtp {
    [ grep &is-prime, (@rtp X~ (1..9)) ]
} ... *;

say "Highest ltp = ", ltp[5][*-1];
say "Highest rtp = ", rtp[5][*-1];
