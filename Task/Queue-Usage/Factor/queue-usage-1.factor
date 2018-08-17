USING: combinators deques dlists kernel prettyprint ;
IN: rosetta-code.queue-usage

DL{ } clone {                ! make new queue
    [ [ 1 ] dip push-front ] ! push 1
    [ [ 2 ] dip push-front ] ! push 2
    [ [ 3 ] dip push-front ] ! push 3
    [ .                    ] ! DL{ 3 2 1 }
    [ pop-back drop        ] ! pop 1 (and discard)
    [ pop-back drop        ] ! pop 2 (and discard)
    [ pop-back drop        ] ! pop 3 (and discard)
    [ deque-empty? .       ] ! t
} cleave
