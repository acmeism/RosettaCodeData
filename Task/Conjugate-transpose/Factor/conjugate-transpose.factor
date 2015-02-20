USING: kernel math.functions math.matrices sequences ;
IN: rosetta.hermitian

: conj-t ( matrix -- conjugate-transpose )
    flip [ [ conjugate ] map ] map ;

: hermitian-matrix? ( matrix -- ? )
    dup conj-t = ;

: normal-matrix? ( matrix -- ? )
    dup conj-t [ m. ] [ swap m. ] 2bi = ;

: unitary-matrix? ( matrix -- ? )
    [ dup conj-t m. ] [ length identity-matrix ] bi = ;
