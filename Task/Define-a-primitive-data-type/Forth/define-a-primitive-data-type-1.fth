DECIMAL
: CLIP  ( n lo hi -- n') ROT MIN MAX ;
: BETWEEN  ( n lo hi -- flag) 1+ WITHIN ;

\ programmer chooses CLIPPED or SAFE integer assignment
: CLIP! ( n addr -- ) SWAP 1 10 CLIP SWAP  ! ;
: SAFE!   ( n addr -- )
          OVER 1 10 BETWEEN 0= ABORT" out of range!"
          ! ;
