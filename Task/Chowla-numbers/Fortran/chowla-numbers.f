        PROGRAM CHOWLA

        CALL PUT_1ST_37
        CALL PUT_PRIME
        CALL PUT_PERFECT

        END

        INTEGER*4 FUNCTION CHOWLA1(N)

C The Chowla number of N is the sum of the divisors of N
C excluding unity and N where N is a positive integer

        IMPLICIT INTEGER*4 (A-Z)

        IF (N .LE. 0) STOP 'Argument to Chowla function must be > 0'

        SUM = 0
        I = 2

 100    CONTINUE
            IF (I * I .GT. N) GOTO 200

            IF (MOD(N, I) .NE. 0) GOTO 110
                J = N / I
                SUM = SUM + I
                IF ( I .NE. J) SUM = SUM + J
 110        CONTINUE

            I = I + 1
        GOTO 100

 200    CONTINUE

        CHOWLA1 = SUM

        RETURN

        END

        SUBROUTINE PUT_1ST_37
        IMPLICIT INTEGER*4 (A-Z)

        DO 100 I = 1, 37
            PRINT 900, I, CHOWLA1(I)
 100    CONTINUE

        RETURN

 900    FORMAT(1H , 'CHOWLA(', I2, ') = ', I2)

        END

        SUBROUTINE PUT_PRIME
        IMPLICIT INTEGER*4 (A-Z)
        PARAMETER LIMIT = 10000000

        COUNT = 0
        POWER = 100

        DO 200 N = 2, LIMIT

            IF (CHOWLA1(N) .EQ. 0) COUNT = COUNT + 1

            IF (MOD(N, POWER) .NE. 0) GOTO 100

                PRINT 900, COUNT, POWER
                POWER = POWER * 10

 100        CONTINUE

 200    CONTINUE

        RETURN

 900    FORMAT(1H ,'There are ', I12, ' primes < ', I12)

        END

        SUBROUTINE PUT_PERFECT
        IMPLICIT INTEGER*4 (A-Z)
        PARAMETER LIMIT = 35000000

        COUNT = 0
        K = 2
        KK = 3

 100    CONTINUE

        P = K * KK

        IF (P .GT. LIMIT) GOTO 300

        IF (CHOWLA1(P) .NE. P - 1) GOTO 200
            PRINT 900, P
            COUNT = COUNT + 1

 200    CONTINUE

        K = KK + 1
        KK = KK + K

        GOTO 100

 300    CONTINUE

        PRINT 910, COUNT, LIMIT

        RETURN

 900    FORMAT(1H , I10, ' is a perfect number')
 910    FORMAT(1H , 'There are ', I10, ' perfect numbers < ', I10)

        END
