divert(-1)

----------------------------------------------------------------------

This is free and unencumbered software released into the public
domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>

----------------------------------------------------------------------

Find a Knight's tour, via Warnsdorff's rule.

For very old or 'Heirloom' m4, you may need to increase the sizes of
internal structures, with, say,

    m4 -S 1000 -B 100000 knights_tour.m4

But I would use one of OpenBSD m4, GNU m4, etc., instead.

----------------------------------------------------------------------

dnl  Get a random number from 0 to one less than $1.
dnl  (Note that this is not a very good RNG. Also it writes a file.)
define(`randnum',
  `syscmd(`echo $RANDOM > __random_number__')eval(include(__random_number__) % ( $1 ))')


dnl  The left deconstructors for strings.
define(`string_car',`substr($1,0,1)')
define(`string_cdr',`substr($1,1)')

dnl   Algebraic notation to 'i0j0', with i the ranks and j the files. Bad
dnl   algebraic notation gets tranformed to '99999999'.
define(`alg2ij',
  `ifelse($1,`a1',`1010',$1,`a2',`2010',$1,`a3',`3010',$1,`a4',`4010',
          $1,`a5',`5010',$1,`a6',`6010',$1,`a7',`7010',$1,`a8',`8010',
          $1,`b1',`1020',$1,`b2',`2020',$1,`b3',`3020',$1,`b4',`4020',
          $1,`b5',`5020',$1,`b6',`6020',$1,`b7',`7020',$1,`b8',`8020',
          $1,`c1',`1030',$1,`c2',`2030',$1,`c3',`3030',$1,`c4',`4030',
          $1,`c5',`5030',$1,`c6',`6030',$1,`c7',`7030',$1,`c8',`8030',
          $1,`d1',`1040',$1,`d2',`2040',$1,`d3',`3040',$1,`d4',`4040',
          $1,`d5',`5040',$1,`d6',`6040',$1,`d7',`7040',$1,`d8',`8040',
          $1,`e1',`1050',$1,`e2',`2050',$1,`e3',`3050',$1,`e4',`4050',
          $1,`e5',`5050',$1,`e6',`6050',$1,`e7',`7050',$1,`e8',`8050',
          $1,`f1',`1060',$1,`f2',`2060',$1,`f3',`3060',$1,`f4',`4060',
          $1,`f5',`5060',$1,`f6',`6060',$1,`f7',`7060',$1,`f8',`8060',
          $1,`g1',`1070',$1,`g2',`2070',$1,`g3',`3070',$1,`g4',`4070',
          $1,`g5',`5070',$1,`g6',`6070',$1,`g7',`7070',$1,`g8',`8070',
          $1,`h1',`1080',$1,`h2',`2080',$1,`h3',`3080',$1,`h4',`4080',
          $1,`h5',`5080',$1,`h6',`6080',$1,`h7',`7080',$1,`h8',`8080',
          `99999999')')

dnl   The reverse of alg2ij. Bad 'i0j0' get transformed to 'z0'.
define(`ij2alg',
  `ifelse($1,`1010',`a1',$1,`2010',`a2',$1,`3010',`a3',$1,`4010',`a4',
          $1,`5010',`a5',$1,`6010',`a6',$1,`7010',`a7',$1,`8010',`a8',
          $1,`1020',`b1',$1,`2020',`b2',$1,`3020',`b3',$1,`4020',`b4',
          $1,`5020',`b5',$1,`6020',`b6',$1,`7020',`b7',$1,`8020',`b8',
          $1,`1030',`c1',$1,`2030',`c2',$1,`3030',`c3',$1,`4030',`c4',
          $1,`5030',`c5',$1,`6030',`c6',$1,`7030',`c7',$1,`8030',`c8',
          $1,`1040',`d1',$1,`2040',`d2',$1,`3040',`d3',$1,`4040',`d4',
          $1,`5040',`d5',$1,`6040',`d6',$1,`7040',`d7',$1,`8040',`d8',
          $1,`1050',`e1',$1,`2050',`e2',$1,`3050',`e3',$1,`4050',`e4',
          $1,`5050',`e5',$1,`6050',`e6',$1,`7050',`e7',$1,`8050',`e8',
          $1,`1060',`f1',$1,`2060',`f2',$1,`3060',`f3',$1,`4060',`f4',
          $1,`5060',`f5',$1,`6060',`f6',$1,`7060',`f7',$1,`8060',`f8',
          $1,`1070',`g1',$1,`2070',`g2',$1,`3070',`g3',$1,`4070',`g4',
          $1,`5070',`g5',$1,`6070',`g6',$1,`7070',`g7',$1,`8070',`g8',
          $1,`1080',`h1',$1,`2080',`h2',$1,`3080',`h3',$1,`4080',`h4',
          $1,`5080',`h5',$1,`6080',`h6',$1,`7080',`h7',$1,`8080',`h8',
          `z0')')

dnl   Move a knight from one square to another by an ij-vector. Both input
dnl   and output are algebraic notation. If the move is illegal, it comes
dnl   out as 'z0'.
define(`move_by',`ij2alg(eval(alg2ij($3) + 1000 * ( $1 ) + 10 * ( $2 )))')

dnl  For example, a1d3c5 -> 3
define(`path_length',`eval(len($1) / 2)')

dnl  The left deconstructors for paths.
define(`path_car',`substr($1,0,2)')
define(`path_cdr',`substr($1,2)')

dnl  The right deconstructors for paths.
define(`path_last',`substr($1,eval(len($1) - 2))')
define(`path_drop_last',`substr($1,0,eval(len($1) - 2))')

dnl  Extract the nth position from the path.
define(`path_nth',`substr($1,eval(( $2 ) * 2),2)')

define(`random_move',`path_nth($1,randnum(path_length($1)))')

dnl  Is the position $1 contained in the path $2?
define(`path_contains',`ifelse(index($2,$1),-1,0,1)')

dnl  Find all moves from position $1 that are not already in
dnl  the path $2.
define(`possible_moves',
`ifelse(path_contains(move_by(1,2,$1),$2`'z0),`0',move_by(1,2,$1))`'dnl
ifelse(path_contains(move_by(2,1,$1),$2`'z0),`0',move_by(2,1,$1))`'dnl
ifelse(path_contains(move_by(1,-2,$1),$2`'z0),`0',move_by(1,-2,$1))`'dnl
ifelse(path_contains(move_by(2,-1,$1),$2`'z0),`0',move_by(2,-1,$1))`'dnl
ifelse(path_contains(move_by(-1,2,$1),$2`'z0),`0',move_by(-1,2,$1))`'dnl
ifelse(path_contains(move_by(-2,1,$1),$2`'z0),`0',move_by(-2,1,$1))`'dnl
ifelse(path_contains(move_by(-1,-2,$1),$2`'z0),`0',move_by(-1,-2,$1))`'dnl
ifelse(path_contains(move_by(-2,-1,$1),$2`'z0),`0',move_by(-2,-1,$1))')

dnl  Count how many moves can follow each move in $1.
define(`follows_counts',
  `ifelse($1,`',`',
          `path_length(possible_moves(path_car($1),$2))`'follows_counts(path_cdr($1),$2)')')

dnl  Find the smallest positive digit, or zero.
define(`min_positive',
  `ifelse($1,`',0,
`pushdef(`min1',min_positive(string_cdr($1)))`'dnl
pushdef(`val1',string_car($1))`'dnl
ifelse(min1,0,val1,
       val1,0,min1,
       eval(val1 < min1),1,val1,min1)`'dnl
popdef(`min1',`val1')')')

dnl  Change everything to zero that is not the minimum positive.
define(`apply_warnsdorff',`_$0(min_positive($1),$1)')
define(`_apply_warnsdorff',
  `ifelse($2,`',`',`ifelse(string_car($2),$1,$1,0)`'$0($1,string_cdr($2))')')

dnl  Find potential next moves that satisfy Warnsdorff's rule.
define(`warnsdorff_moves',
`pushdef(`moves',`possible_moves($1,$2)')`'dnl
pushdef(`selections',`apply_warnsdorff(follows_counts(moves))')`'dnl
_$0(moves,selections)`'dnl
popdef(`moves',`selections')')
define(`_warnsdorff_moves',
`ifelse($1,`',`',
`ifelse(string_car($2),0,`$0(path_cdr($1),string_cdr($2))',
        `path_car($1)`'$0(path_cdr($1),string_cdr($2))')')')

dnl  Find potential next moves for the given path.
define(`next_moves',
`ifelse(path_length($1),63,`possible_moves(path_last($1),$1)',
        `warnsdorff_moves(path_last($1),$1)')')

define(`find_tour',
`ifelse($2,`',`find_tour($1,$1)',
        path_length($2),64,$2,
`pushdef(`moves',next_moves($2))`'dnl
ifelse(moves,`',`find_tour($1)',
       `find_tour($1,$2`'random_move(next_moves($2)))')`'dnl
popdef(`moves')')')

divert`'dnl
dnl
find_tour(a1)
find_tour(c5)
find_tour(h8)
