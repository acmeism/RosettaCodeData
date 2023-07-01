MAX_ITER := 15.
#(
  (-2  2  1 'Normal')
  (-2  2  0 'Zero increment')
  (-2  2 -1 'Increments away from stop value')
  (-2  2 10 'First increment is beyond stop value')
  (2  -2  1 'Start more than stop: positive increment')
  (2   2  1 'Start equal stop: positive increment')
  (2   2 -1 'Start equal stop: negative increment')
  (2   2  0 'Start equal stop: zero increment')
  (0   0  0 'Start equal stop equal zero: zero increment')
) do:[:testParams |
    |start stop inc info countIter|

    start := testParams first.
    stop := testParams second.
    inc := testParams third.
    info := testParams fourth.
    Transcript show:(info paddedTo:50 with:$.).

    countIter := 0.
    [:exit |
        start to:stop by:inc do:[:n |
            Transcript space; show:n.
            (countIter := countIter + 1) > MAX_ITER ifTrue:[
                Transcript show:'...'.
                exit value
            ].
        ].
    ] valueWithExit.
    Transcript cr.
].
