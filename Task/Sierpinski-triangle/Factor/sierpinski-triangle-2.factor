USING: command-line io io.streams.string kernel math math.parser
namespaces sequences ;
IN: sierpinski

: plot ( i j -- )
    bitand zero? "* " "  " ? write ;

: pad ( n -- )
    1 - [ " " write ] times ;

: plot-row ( n -- )
    dup 1 + [ tuck - plot ] with each-integer ;

: sierpinski ( n -- )
    dup '[ _ over - pad plot-row nl ] each-integer ;
