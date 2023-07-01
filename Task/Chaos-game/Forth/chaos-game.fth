#! /usr/bin/gforth
\ Chaos Game

require random.fs

\ initialize the random number generator with a time-dependent seed
utime drop seed !

\ parses a number from a string
: parse-number ( -- n )
    s>number? invert throw drop
;


\ parse the width of the triangle, the number of steps and the output filename from the command-line

." width:  " next-arg parse-number dup  .    cr CONSTANT  WIDTH
." steps:  " next-arg parse-number dup  .    cr CONSTANT  STEPS
." output: " next-arg              2dup type cr 2CONSTANT OUT-FILE


\ height of the triangle: height = sqrt(3) / 2 * width
WIDTH 0 d>f 3e fsqrt f* 2e f/ fround f>d drop CONSTANT HEIGHT  \ height of the triangle: height = sqrt(3) / 2 * width


\ coordinates of the three corners of the triangle

0         CONSTANT X1
0         CONSTANT Y1
WIDTH     CONSTANT X2
0         CONSTANT Y2
WIDTH 2 / CONSTANT X3
HEIGHT    CONSTANT Y3


\ minimal and maximal x and y coordinates

X1 X2 X3 min min CONSTANT XMIN
X1 X2 X3 max max CONSTANT XMAX
Y1 Y2 Y3 min min CONSTANT YMIN
Y1 Y2 Y3 max max CONSTANT YMAX

XMAX XMIN - 1+ CONSTANT XSIZE
YMAX YMIN - 1+ CONSTANT YSIZE


\ initialize array for all possible points

XSIZE YSIZE *
dup CREATE ARR cells allot
ARR swap cells erase


\ address of the cell corresponding to point (x,y)
: addr? ( x y -- addr )
    XSIZE * + cells ARR +
;

\ scalar product of the 2-vectors
: sp ( x1 y1 x2 y2 -- n )
    swap >r * r> rot * +
;

\ is the point (x,y) on the left of the ray from (px,py) to (qx,qy)?
: left? ( px py qx qy x y -- f )
    { px py qx qy x y }
    py qy -
    qx px -
    x  px -
    y  py -
    sp 0>=
;

\ is the point (x,y) in the triangle?
: in-triangle? ( x y -- f )
    { x y }
    X1 Y1 X2 Y2 x y left?
    X2 Y2 X3 Y3 x y left?
    X3 Y3 X1 Y1 x y left?
    and and
;

\ generates a random number in [a,b]
: random-in-range ( a b -- n )
    over - 1+ random +
;

\ generates a random point in the triangle
: random-in-triangle ( -- x y )
    0 0
    BEGIN
        2drop
        XMIN XMAX random-in-range
        YMIN YMAX random-in-range
        2dup in-triangle?
    UNTIL
;

\ finds the middle of to points (px,py) and (qx,qy)
: middle ( px py qx qy -- x y )
    swap -rot
    + 2/ -rot
    + 2/ swap
;

\ plays the chaos game for a number of steps
: game ( n -- )
    random-in-triangle
    rot
    0 DO
        2dup addr? true swap !
        3 random CASE
            0 OF X1 Y1 ENDOF
            1 OF X2 Y2 ENDOF
            2 OF X3 Y3 ENDOF
        ENDCASE
        middle
    LOOP
    2drop
;

\ writes the result in pbm-format
: write-pbm ( -- )
    ." P1" cr
    XSIZE . YSIZE . cr
    YMIN 1- YMAX -DO
        XMAX 1+ XMIN DO
            i j addr? @ IF 1 . ELSE 0 . THEN
        LOOP
        cr
    1 -LOOP
;

\ writes the result to a pbm-file
: to-pbm ( c-addr u -- )
    w/o create-file throw ['] write-pbm over outfile-execute close-file throw
;

\ play the game and save the result
STEPS game OUT-FILE to-pbm

bye
