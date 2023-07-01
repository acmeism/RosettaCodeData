USING: arrays kernel math math.matrices math.vectors ;

: rgb>gray ( matrix -- new-matrix )
    [ { 0.2126 0.7152 0.0722 } vdot >integer ] matrix-map ;

: gray>rgb ( matrix -- new-matrix )
    [ dup dup 3array ] matrix-map ;
