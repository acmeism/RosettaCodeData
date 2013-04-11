USING: arrays fry kernel math prettyprint sequences ;
IN: hof
CONSTANT: x  2.0
CONSTANT: xi 0.5
CONSTANT: y  4.0
CONSTANT: yi .25
: z ( -- z )
    << x y + suffix! >> ; inline
: zi ( -- zi )
    << 1 x y + / suffix! >> ; inline
: numbers ( -- numbers )
    << x y z 3array suffix! >> ; inline
: inverses ( -- inverses )
    << xi yi zi 3array suffix! >> ; inline
CONSTANT: m 0.5
: multiplyer ( n1 n2 -- q )
    '[ _ _ * * ] ; inline
: go ( n1 n2 -- )
    2dup [ empty? ] bi@ or not ! either empty
    [
        [ [ first ] bi@ multiplyer m swap call . ]
        [ [ rest-slice ] bi@ go ] 2bi
    ] [ 2drop ] if ;
