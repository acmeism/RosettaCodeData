USING: accessors images images.loader kernel literals math
math.bits math.functions make sequences ;
IN: rosetta-code.sierpinski-triangle-graphical

CONSTANT: black B{ 33  33  33  255 }
CONSTANT: white B{ 255 255 255 255 }
CONSTANT: size  $[ 2 8 ^ ]           ! edit 8 to change order

! Generate Sierpinksi's triangle sequence. This is sequence
! A001317 in OEIS.

: sierpinski ( n -- seq )
    [ [ 1 ] dip [ dup , dup 2 * bitxor ] times ] { } make nip ;

! Convert a number to binary, then append a black pixel for each
! set bit or a white pixel for each unset bit to the image being
! built by make.

: expand ( n -- ) make-bits [ black white ? % ] each ;

! Append white pixels until the end of the row in the image
! being built by make.

: pad ( n -- ) [ size ] dip 1 + - [ white % ] times ;

! Generate the image data for a sierpinski triangle of a given
! size in pixels. The image is square so its dimensions are
! n x n.

: sierpinski-img ( n -- seq )
    sierpinski [ [ [ expand ] dip pad ] each-index ] B{ } make ;

: main ( -- )
    <image>
    ${ size size }      >>dim
    BGRA                >>component-order
    ubyte-components    >>component-type
    size sierpinski-img >>bitmap
    "sierpinski-triangle.png" save-graphic-image ;

MAIN: main
