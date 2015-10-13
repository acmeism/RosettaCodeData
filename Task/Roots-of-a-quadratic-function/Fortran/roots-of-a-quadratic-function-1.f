PROGRAM QUADRATIC

 IMPLICIT NONE
 INTEGER, PARAMETER :: dp = SELECTED_REAL_KIND(15)
 REAL(dp) :: a, b, c, e, discriminant, rroot1, rroot2
 COMPLEX(dp) :: croot1, croot2

 WRITE(*,*) "Enter the coefficients of the equation ax^2 + bx + c"
 WRITE(*, "(A)", ADVANCE="NO") "a = "
 READ *, a
 WRITE(*,"(A)", ADVANCE="NO") "b = "
 READ *, b
 WRITE(*,"(A)", ADVANCE="NO") "c = "
 READ *, c

 WRITE(*,"(3(A,E23.15))") "Coefficients are: a = ", a, "   b = ", b, "   c = ", c
 e = 1.0e-9_dp
 discriminant = b*b - 4.0_dp*a*c

 IF (ABS(discriminant) < e) THEN
    rroot1 = -b / (2.0_dp * a)
    WRITE(*,*) "The roots are real and equal:"
    WRITE(*,"(A,E23.15)") "Root = ", rroot1
 ELSE IF (discriminant > 0) THEN
    rroot1 = -(b + SIGN(SQRT(discriminant), b)) / (2.0_dp * a)
    rroot2 = c / (a * rroot1)
    WRITE(*,*) "The roots are real:"
    WRITE(*,"(2(A,E23.15))") "Root1 = ", rroot1, "  Root2 = ", rroot2
 ELSE
    croot1 = (-b + SQRT(CMPLX(discriminant))) / (2.0_dp*a)
    croot2 = CONJG(croot1)
    WRITE(*,*) "The roots are complex:"
    WRITE(*,"(2(A,2E23.15,A))") "Root1 = ", croot1, "j ", "  Root2 = ", croot2, "j"
 END IF
