USING: kernel math.matrices math.matrices.elimination
prettyprint sequences ;

! Augment a matrix with its identity. E.g.
!
! 1 2 3                        1 2 3 1 0 0
! 4 5 6  augment-identity  ->  4 5 6 0 1 0
! 7 8 9                        7 8 9 0 0 1

: augment-identity ( matrix -- new-matrix )
    dup first length <identity-matrix>
    [ flip ] bi@ append flip ;

! Note: the 'solution' word finds the reduced row echelon form
! of a matrix.

: gauss-jordan-invert ( matrix -- inverted )
    dup square-matrix? [ "Matrix must be square." throw ] unless
    augment-identity solution

    ! now remove the vestigial identity portion of the matrix
    flip halves nip flip ;

{
    { -1 -2 3 2 }
    { -4 -1 6 2 }
    {  7 -8 9 1 }
    {  1 -2 1 3 }
} gauss-jordan-invert simple-table.
