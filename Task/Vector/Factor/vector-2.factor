USING: accessors arrays kernel math parser prettyprint
prettyprint.custom sequences ;
IN: rosetta-code.vector

TUPLE: vec { x real read-only } { y real read-only } ;
C: <vec> vec

<PRIVATE

: parts ( vec -- x y ) [ x>> ] [ y>> ] bi ;
: devec ( vec1 vec2 -- x1 y1 x2 y2 ) [ parts ] bi@ rot swap ;

: binary-op ( vec1 vec2 quot -- vec3 )
    [ devec ] dip 2bi@ <vec> ; inline

: scalar-op ( vec1 scalar quot -- vec2 )
    [ parts ] 2dip curry bi@ <vec> ; inline

PRIVATE>

SYNTAX: VEC{ \ } [ first2 <vec> ] parse-literal ;

: v+ ( vec1 vec2   -- vec3 ) [ + ] binary-op ;
: v- ( vec1 vec2   -- vec3 ) [ - ] binary-op ;
: v* ( vec1 scalar -- vec2 ) [ * ] scalar-op ;
: v/ ( vec1 scalar -- vec2 ) [ / ] scalar-op ;

M: vec pprint-delims drop \ VEC{ \ } ;
M: vec >pprint-sequence parts 2array ;
M: vec pprint* pprint-object ;
