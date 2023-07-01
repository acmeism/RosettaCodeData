USING: accessors images images.loader kernel math sequences ;
IN: rosetta-code.munching-squares

: img-data ( -- seq ) 256 sq [ B{ 0 0 0 255 } ] replicate ;

: (munching) ( elt index -- elt' )
    256 /mod bitxor [ rest ] dip prefix ;

: munching ( -- seq )
    img-data [ (munching) ] map-index B{ } concat-as ;

: <munching-img> ( -- img )
    <image>
    { 256 256 }      >>dim
    BGRA             >>component-order
    ubyte-components >>component-type
    munching         >>bitmap ;

: main ( -- ) <munching-img> "munching.png" save-graphic-image ;

MAIN: main
