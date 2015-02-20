   o=. @: NB. Composition of verbs (functions)
   ( PascalTriangle=. i. ((+/\@]^:[)) #&1 ) 5
1 1  1  1  1
1 2  3  4  5
1 3  6 10 15
1 4 10 20 35
1 5 15 35 70
   ( MiddleDiagonal=. (<0 1)&|: )               o PascalTriangle 5
1 2 6 20 70
   ( AdjacentLeft=.   MiddleDiagonal o (2&|.) ) o PascalTriangle 5
1 4 15 1 5

   ( Catalan=. }: o (}. o MiddleDiagonal - }: o AdjacentLeft) o PascalTriangle o (2&+) f. ) 5
1 2 5 14 42

   Catalan
}:@:(}.@:((<0 1)&|:) - }:@:((<0 1)&|:@:(2&|.)))@:(i. +/\@]^:[ #&1)@:(2&+)
