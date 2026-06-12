!
! The greatest source of apparent error in comparing the input and the regenerated output, was the I/O itself.
! So, I added a comparison of the original and the regenerated number.
! As the routines use 128 bit reals, I was able to achieve great accuracy, even with the extra long optional values
!
    MODULE EngelModule
    IMPLICIT NONE
    CONTAINS

SUBROUTINE ConvertToEngelSeries(number, engel_terms, count)
    use iso_fortran_env
    IMPLICIT NONE
    REAL(real128), INTENT(IN) :: number
    INTEGER(int64), ALLOCATABLE, INTENT(OUT) :: engel_terms(:)
    INTEGER, INTENT(OUT) :: count

    REAL(real128) :: x
    INTEGER :: i, max_terms
    max_terms = 10000  ! Maximum number of terms to calculate
    if(allocated(engel_terms))deallocate(engel_terms)
    ALLOCATE(engel_terms(max_terms))

    x = number
    count = 0

    DO i = 1, max_terms
        IF (x < 0.0_real128)then !We went too far
            count = max(0,count-1)
            EXIT
        endif

        engel_terms(i) = CEILING(1.0_real128 / x)
        x = x * engel_terms(i) - 1.0_real128
        count = count + 1
    END DO

    ! Resize the array to the actual number of terms
    IF (count < max_terms) THEN
        engel_terms = engel_terms(1:count)
    END IF
END SUBROUTINE ConvertToEngelSeries

FUNCTION engeldec(a, n) RESULT(x)
    use iso_fortran_env
    IMPLICIT NONE
    INTEGER, INTENT(IN) :: n            ! Size of array
    INTEGER(int64), INTENT(IN) :: a(n)  ! Input array
    REAL(real128) :: x                  ! Result
    REAL(real128) :: p                  ! Product accumulator
    INTEGER :: i                        ! Loop counter

    x = 0.0_real128
    p = 1.0_real128
    DO i = 1, n
        p = p * a(i)
        x = x + 1.0_real128 / p
    END DO
END FUNCTION engeldec

END MODULE EngelModule
PROGRAM main
    USE EngelModule
    USE iso_fortran_env
    IMPLICIT NONE

    REAL(real128) :: rationals(6), tempo
    INTEGER(int64), ALLOCATABLE :: engel(:)
    INTEGER :: i, countz, j, lenn
    CHARACTER(110) :: str

    ! Initialize rational numbers
    str = '3.14159265358979'  ! PI
    lenn = LEN_TRIM(str) - INDEX(str, '.')
    READ(str, *) rationals(1)

    str = '2.718281828459045'  ! e
    READ(str, *) rationals(2)

    str = '1.414213562373095'  ! sqrt(2)
    READ(str, *) rationals(3)

    str = '4.25'
    READ(str, *) rationals(4)

    str = '1.618033988749895'  ! Golden Ratio
    READ(str, *) rationals(5)

    str = '2024.00000000000'  ! Integer
    READ(str, *) rationals(6)

    WRITE(str, '(a, I0, a, I0, a)') '(a, F', lenn + 5, '.', lenn, ', 1x)'

    DO i = 1, 6
        PRINT '(a, 1x, f19.14)', "Rational number:", rationals(i)
        CALL ConvertToEngelSeries(rationals(i), engel, countz)
        PRINT *, 'Number of terms returned = ', countz

        IF (countz < 36) THEN
            PRINT *, "Engel expansion:", (engel(j), j = 1, countz)
        ELSE
            PRINT *, 'Too many terms to print'
        END IF
        tempo = engeldec(engel, countz)
        PRINT TRIM(str), "Back to rational:", tempo
        PRINT '(a,1x, e8.2, /)', 'Numerical difference is', rationals(i) - tempo
    END DO

    ! Let's try a few big ones
    PRINT '(/, a)', REPEAT('*', 30)
    PRINT *, 'Attempting the larger numbers'
    PRINT '(a, /)', REPEAT('*', 30)

    str = '2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642743'
    READ(str, *) rationals(1)

    str = &
    '3.141592653589793238462643383279502884197169399375105820974944592'// &
    '078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211'
    READ(str, *) rationals(2)

    str = &
    '1.41421356237309504880168872420969807856967187537694807317667973799073247'//&
    '84621070388503875343276415727350138462309122970249248360558507372126441214970999358314132226659275055927558'
    READ(str, *) rationals(3)
    str = &
    '4.38675679870707708463663533353637349867070077766333363636363636363758770'//&
    '12345678900707069857635363522434325769792911797652456607508494179765523412486070797587867373633636368678088'
    READ(str, *) rationals(4)
    DO i = 1, 4
        PRINT *, 'Input number =', rationals(i)
        CALL ConvertToEngelSeries(rationals(i), engel, countz)
        PRINT *, 'Number of terms returned =', countz

        IF (countz < 36) THEN
            PRINT *, "Engel expansion:", (engel(j), j = 1, countz)
        ELSE
            PRINT *, 'Too many terms to print'
        END IF

        tempo = engeldec(engel, countz)
        PRINT *, "Back to rational:", tempo
        PRINT '(a,1x, e8.2, /)', 'Numerical difference is', rationals(i) - tempo
    END DO
END PROGRAM main
