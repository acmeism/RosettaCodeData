DL{ } clone {
    [ [ { 1 2 3 } ] dip push-all-front ] ! push all from sequence
    [ .                                ] ! DL{ 3 2 1 }
    [ [ drop ] slurp-deque             ] ! pop and discard all
    [ deque-empty? .                   ] ! t
} cleave
