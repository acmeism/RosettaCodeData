test06b_MiscMath_errors
    self should:[ 0 ln ] raise:DomainError.
    self should:[ 0 log2 ] raise:DomainError.
    self should:[ 0 log10 ] raise:DomainError.
    self should:[ -1 ln ] raise:DomainError.
    self should:[ -1 log2 ] raise:DomainError.
    self should:[ -1 log10 ] raise:DomainError.

test_integerSqrt
    |n sqrt f|

    n := 1000 factorial.
    sqrt := n integerSqrt.
    self assert:(sqrt squared <= n).
    self assert:((sqrt+1) squared > n).
    n := sqrt := nil.

    self should:[-10 integerSqrt] raise:DomainError.
