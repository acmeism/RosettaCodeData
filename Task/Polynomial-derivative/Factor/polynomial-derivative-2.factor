USING: kernel math.vectors sequences ;
IN: math.polynomials
: pdiff ( p -- p' ) dup length <iota> v* rest ;
