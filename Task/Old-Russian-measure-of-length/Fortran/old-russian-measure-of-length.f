PROGRAM RUS
 IMPLICIT NONE
 REAL, PARAMETER:: E_m = 1.
 REAL, PARAMETER:: E_mm = 1.E-3
 REAL, PARAMETER:: E_km = 1.E+3
 REAL, PARAMETER:: E_cm = 1.E-2
 REAL, PARAMETER:: E_arshin = 71.12 * E_cm
 REAL, PARAMETER:: E_fut = 3./7. * E_arshin
 REAL, PARAMETER:: E_piad = 1./4. * E_arshin
 REAL, PARAMETER:: E_vershok = 1./16. * E_arshin
 REAL, PARAMETER:: E_dyuim = 1./28. * E_arshin
 REAL, PARAMETER:: E_liniya = 1./280. * E_arshin
 REAL, PARAMETER:: E_tochka = 1./2800. * E_arshin
 REAL, PARAMETER:: E_ladon = 7.5 * E_cm
 REAL, PARAMETER:: E_lokot = 45 * E_cm
 REAL, PARAMETER:: E_sazhen = 3. * E_arshin
 REAL, PARAMETER:: E_versta = 1500. * E_arshin
 REAL, PARAMETER:: E_milya = 10500. * E_arshin
 INTEGER, PARAMETER:: N = 16
 CHARACTER(LEN=7), DIMENSION(N):: nam = (/&
  &'m      ', 'mm     ', 'km     ', 'cm     ',&
  &'arshin ', 'fut    ', 'piad   ', 'vershok',&
  &'dyuim  ', 'liniya ', 'tochka ', 'ladon  ',&
  &'lokot  ', 'sazhen ', 'versta ', 'milya  ' /)
 REAL, DIMENSION(N):: wert = (/ &
  &1., E_mm, E_km, E_cm,&
  &E_arshin, E_fut, E_piad, E_vershok,&
  &E_dyuim, E_liniya, E_tochka, E_ladon,&
  &E_lokot, E_sazhen, E_versta, E_milya /)
 CHARACTER(LEN=7):: RD_U
 REAL:: RD_V
 INTEGER:: I, J
 DO I=1, N
  WRITE(*, '(A, " ")', ADVANCE='NO')  nam(I)
 END DO
 WRITE (*, *)
 WRITE(*, '(A)', ADVANCE='NO') 'value unit -> '
 READ(*, *) RD_V, RD_U
 RD_U = ADJUSTL(RD_U)
 J = 1
 DO WHILE (NAM(J) .NE. RD_U)
  J = J + 1
  IF (J .GT. N) STOP "Unit not known: "//RD_U
 END DO
 RD_V = RD_V * wert(J)
 DO I=1, N
  J = J + 1
  IF (J .GT. N) J = 1
  WRITE (*, '(F20.3, " ", A)') RD_V / wert(J), nam(J)
 END DO
END PROGRAM RUS
