MODULE INTEGER_SQUARE_ROOT
    IMPLICIT NONE

    CONTAINS

    ! Convert string representation number to string with comma digit separation
    FUNCTION COMMATIZE(NUM) RESULT(OUT_STR)
         INTEGER(16), INTENT(IN) :: NUM
         INTEGER(16) I
         CHARACTER(83) :: TEMP, OUT_STR

         WRITE(TEMP, '(I0)') NUM

         OUT_STR = ""

         DO I=0, LEN_TRIM(TEMP)-1
             IF (MOD(I, 3) .EQ. 0 .AND. I .GT. 0 .AND. I .LT. LEN_TRIM(TEMP)) THEN
                  OUT_STR = "," // TRIM(OUT_STR)
             END IF
             OUT_STR = TEMP(LEN_TRIM(TEMP)-I:LEN_TRIM(TEMP)-I) // TRIM(OUT_STR)
         END DO
    END FUNCTION COMMATIZE


    ! Calculate the integer square root for a given integer
    FUNCTION ISQRT(NUM)
        INTEGER(16), INTENT(IN) :: NUM
        INTEGER(16) :: ISQRT
        INTEGER(16) :: Q, Z, R, T

        Q = 1
        Z = NUM
        R = 0
        T = 0

        DO WHILE (Q .LE. NUM)
            Q = Q * 4
        END DO

        DO WHILE (Q .GT. 1)
            Q = Q / 4
            T = Z - R - Q
            R = R / 2

            IF (T .GE. 0) THEN
                Z = T
                R = R + Q
            END IF
        END DO

        ISQRT = R
    END FUNCTION ISQRT

END MODULE INTEGER_SQUARE_ROOT


! Demonstration of integer square root for numbers 0-65 followed by odd powers of 7
! from 1-73. Currently this demo takes significant time for numbers above 43
PROGRAM ISQRT_DEMO
    USE INTEGER_SQUARE_ROOT
    IMPLICIT NONE


    INTEGER(16), PARAMETER :: MIN_NUM_HZ = 0
    INTEGER(16), PARAMETER :: MAX_NUM_HZ = 65
    INTEGER(16), PARAMETER :: POWER_BASE = 7
    INTEGER(16), PARAMETER :: POWER_MIN = 1
    INTEGER(16), PARAMETER :: POWER_MAX = 73
    INTEGER(16), DIMENSION(MAX_NUM_HZ-MIN_NUM_HZ+1) :: VALUES
    CHARACTER(2) :: HEADER_1
    CHARACTER(83) :: HEADER_2
    CHARACTER(83) :: HEADER_3

    INTEGER(16) :: I

    HEADER_1 = " n"
    HEADER_2 = "7^n"
    HEADER_3 = "isqrt(7^n)"

    WRITE(*,'(A, I0, A, I0)') "Integer square root for numbers ", MIN_NUM_HZ, " to ", MAX_NUM_HZ

    DO I=1, SIZE(VALUES)
        VALUES(I) = ISQRT(MIN_NUM_HZ+I)
    END DO

    WRITE(*,'(100I2)') VALUES
    WRITE(*,*) NEW_LINE('A')

    WRITE(*,'(A,A,A,A,A)') HEADER_1, " | ", HEADER_2, " | ", HEADER_3
    WRITE(*,*) REPEAT("-", 8+83*2)

    DO I=POWER_MIN,POWER_MAX, 2
        WRITE(*,'(I2, A, A, A, A)') I, " | " // COMMATIZE(7**I), " | ", COMMATIZE(ISQRT(7**I))
    END DO


 END PROGRAM ISQRT_DEMO
