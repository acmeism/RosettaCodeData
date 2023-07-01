PROGRAM Roots

  COMPLEX :: root
  INTEGER :: i, n
  REAL :: angle, pi

  pi = 4.0 * ATAN(1.0)
  DO n = 2, 7
    angle = 0.0
    WRITE(*,"(I1,A)", ADVANCE="NO") n,": "
    DO i = 1, n
      root = CMPLX(COS(angle), SIN(angle))
      WRITE(*,"(SP,2F7.4,A)", ADVANCE="NO") root, "j  "
      angle = angle + (2.0*pi / REAL(n))
    END DO
    WRITE(*,*)
  END DO

END PROGRAM Roots
