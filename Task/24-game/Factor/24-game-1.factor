USING:
    combinators.short-circuit
    continuations
    eval
    formatting
    fry
    kernel
    io
    math math.ranges
    prettyprint
    random
    sequences
    sets ;
IN: 24game

: choose4 ( -- seq )
    4 [ 9 [1,b] random ] replicate ;

: step ( numbers -- ? )
    readln
    [
        parse-string
        {
            ! Is only allowed tokens used?
            [ swap { + - / * } append subset? ]
            ! Digit count in expression should be equal to the given numbers.
            [ [ number? ] count swap length = ]
            ! Of course it must evaluate to 24
            [ nip call( -- x ) 24 = ]
        } 2&&
        [ f "You got it!" ]
        [ t "Expression isnt valid, or doesnt evaluate to 24." ]
        if
    ]
    [ 3drop f "Could not parse that." ]
    recover print flush ;

: main ( -- )
    choose4
    [ "Your numbers are %[%s, %], make an expression\n" printf flush ]
    [ '[ _ step ] loop ]
    bi ;
