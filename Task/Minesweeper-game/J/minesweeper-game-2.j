   load 'minefield.ijs'
   fld=: Minesweeper 6 4
=== MineSweeper ===
Object:
   Uncover (clear) all the tiles that are not mines.

How to play:
 - the left, top tile is: 1 1
 - clear an uncleared tile (.) using the command:
      clear__fld <column index> <row index>
 - mark and uncleared tile (?) as a suspected mine using the command:
      mark__fld <column index> <row index>
 - if you uncover a number, that is the number of mines adjacent
   to the tile
 - if you uncover a mine (*) the game ends (you lose)
 - if you uncover all tiles that are not mines the game ends (you win).
 - quit a game before winning or losing using the command:
      quit__fld ''
 - start a new game using the command:
      fld=: MineSweeper <num columns> <num rows>

0 of 5 mines marked.
┌──────┐
│......│
│......│
│......│
│......│
└──────┘
   clear__fld 1 1
0 of 5 mines marked.
┌──────┐
│2.....│
│......│
│......│
│......│
└──────┘
   clear__fld 6 4
0 of 5 mines marked.
┌──────┐
│2..2  │
│...2  │
│..31  │
│..1   │
└──────┘
   mark__fld 3 1 ,: 3 2               NB. mark and clear both accept lists of coordinates
2 of 5 mines marked.
┌──────┐
│2.?2  │
│..?2  │
│..31  │
│..1   │
└──────┘
   clear__fld 1 2 , 1 3 ,: 1 4
2 of 5 mines marked.
┌──────┐
│2.?2  │
│3.?2  │
│2.31  │
│1.1   │
└──────┘
   clear__fld 2 1
KABOOM!!
┌──────┐
│2**2  │
│3**2  │
│2*31  │
│111   │
└──────┘
You lost! Try again?
   fld=: Minesweeper 20 10            NB. create bigger minefield
...                                   NB. instructions elided
0 of 50 mines marked.
┌────────────────────┐
│....................│
│....................│
│....................│
│....................│
│....................│
│....................│
│....................│
│....................│
│....................│
│....................│
└────────────────────┘
   clear__fld >: 4$.$. 9 >  Map__fld  NB. Autosolve ;-)
Minefield cleared.
┌────────────────────┐
│1***2**2**2*2*2*1111│
│123222222221212222*1│
│11          1223*421│
│*3321   11223**5**1 │
│3***211 1*2**6**432 │
│2*433*222223**423*2 │
│1111*4*4*2 13*2 3*41│
│11112*3**321211 2**1│
│3*3112334*3*211 1332│
│***1 1*12*312*1  1*1│
└────────────────────┘
You won! Try again?
