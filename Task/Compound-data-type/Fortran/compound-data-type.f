program typedemo
    type rational                                           ! Type declaration
        integer :: numerator
        integer :: denominator
    end type rational

    type( rational ), parameter :: zero = rational( 0, 1 )  ! Variables initialized
    type( rational ), parameter :: one  = rational( 1, 1 )  ! by constructor syntax
    type( rational ), parameter :: half = rational( 1, 2 )
    integer :: n, halfd, halfn
    type( rational ) :: &
        one_over_n(20) = (/ (rational( 1, n ), n = 1, 20) /) ! Array initialized with
                                                             ! constructor inside
                                                             ! implied-do array initializer
    integer :: oon_denoms(20)

    halfd = half%denominator                       ! field access with "%" delimiter
    halfn = half%numerator

    oon_denoms = one_over_n%denominator            ! Access denominator field in every
                                                   ! rational array element & store
end program typedemo                               ! as integer array
