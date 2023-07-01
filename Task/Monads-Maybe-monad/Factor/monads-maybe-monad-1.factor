USING: monads ;
FROM: monads => do ;

! Prints "T{ just { value 7 } }"
3 maybe-monad return >>= [ 2 * maybe-monad return ] swap call
                     >>= [ 1 + maybe-monad return ] swap call .

! Prints "nothing"
nothing >>= [ 2 * maybe-monad return ] swap call
        >>= [ 1 + maybe-monad return ] swap call .
