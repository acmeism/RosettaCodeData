MODULE LAW_OF_COSINES
    IMPLICIT NONE

    CONTAINS

    ! Calculate the third side of a triangle using the cosine rule
    REAL FUNCTION COSINE_SIDE(SIDE_A, SIDE_B, ANGLE)
        INTEGER, INTENT(IN) :: SIDE_A, SIDE_B
        REAL(8), INTENT(IN) :: ANGLE

        COSINE_SIDE = SIDE_A**2 + SIDE_B**2 - 2*SIDE_A*SIDE_B*COS(ANGLE)
        COSINE_SIDE = COSINE_SIDE**0.5
    END FUNCTION COSINE_SIDE

    ! Convert an angle in degrees to radians
    REAL(8) FUNCTION DEG2RAD(ANGLE)
        REAL(8), INTENT(IN) :: ANGLE
        REAL(8), PARAMETER :: PI = 4.0D0*DATAN(1.D0)

        DEG2RAD = ANGLE*(PI/180)
    END FUNCTION DEG2RAD

    ! Sort an array of integers
    FUNCTION INT_SORTED(ARRAY) RESULT(SORTED)
        INTEGER, DIMENSION(:), INTENT(IN) :: ARRAY
        INTEGER, DIMENSION(SIZE(ARRAY)) :: SORTED, TEMP
        INTEGER :: MAX_VAL, DIVIDE

        SORTED = ARRAY
        TEMP = ARRAY
        DIVIDE = SIZE(ARRAY)

        DO WHILE (DIVIDE .NE. 1)
            MAX_VAL = MAXVAL(SORTED(1:DIVIDE))
            TEMP(DIVIDE) = MAX_VAL
            TEMP(MAXLOC(SORTED(1:DIVIDE))) = SORTED(DIVIDE)
            SORTED = TEMP
            DIVIDE = DIVIDE - 1
        END DO
    END FUNCTION INT_SORTED

    ! Append an integer to the end of an array of integers
    SUBROUTINE APPEND(ARRAY, ELEMENT)
        INTEGER, DIMENSION(:), ALLOCATABLE, INTENT(INOUT) :: ARRAY
        INTEGER, DIMENSION(:), ALLOCATABLE :: TEMP
        INTEGER :: ELEMENT
        INTEGER :: I, ISIZE

        IF (ALLOCATED(ARRAY)) THEN
            ISIZE = SIZE(ARRAY)
            ALLOCATE(TEMP(ISIZE+1))

            DO I=1, ISIZE
                TEMP(I) = ARRAY(I)
            END DO

            TEMP(ISIZE+1) = ELEMENT

            DEALLOCATE(ARRAY)

            CALL MOVE_ALLOC(TEMP, ARRAY)
        ELSE
            ALLOCATE(ARRAY(1))
            ARRAY(1) = ELEMENT
        END IF

    END SUBROUTINE APPEND

    ! Check if an array of integers contains a subset
    LOGICAL FUNCTION CONTAINS_ARR(ARRAY, ELEMENT)
        INTEGER, DIMENSION(:), INTENT(IN) :: ARRAY
        INTEGER, DIMENSION(:) :: ELEMENT
        INTEGER, DIMENSION(SIZE(ELEMENT)) :: TEMP, SORTED_ELEMENT
        INTEGER :: I, COUNTER, J

        COUNTER = 0

        ELEMENT = INT_SORTED(ELEMENT)

        DO I=1,SIZE(ARRAY),SIZE(ELEMENT)
            TEMP = ARRAY(I:I+SIZE(ELEMENT)-1)
            DO J=1,SIZE(ELEMENT)
                IF (ELEMENT(J) .EQ. TEMP(J)) THEN
                    COUNTER = COUNTER + 1
                END IF
            END DO

            IF (COUNTER .EQ. SIZE(ELEMENT)) THEN
                CONTAINS_ARR = .TRUE.
                RETURN
            END IF
        END DO

        CONTAINS_ARR = .FALSE.
    END FUNCTION CONTAINS_ARR

    ! Count and print cosine triples for the given angle in degrees
    INTEGER FUNCTION COSINE_TRIPLES(MIN_NUM, MAX_NUM, ANGLE, PRINT_RESULTS) RESULT(COUNTER)
        INTEGER, INTENT(IN) :: MIN_NUM, MAX_NUM
        REAL(8), INTENT(IN) :: ANGLE
        LOGICAL, INTENT(IN) :: PRINT_RESULTS
        INTEGER, DIMENSION(:), ALLOCATABLE :: CANDIDATES
        INTEGER, DIMENSION(3) :: CANDIDATE
        INTEGER :: A, B
        REAL :: C

        COUNTER = 0

        DO A = MIN_NUM, MAX_NUM
            DO B = MIN_NUM, MAX_NUM
                C = COSINE_SIDE(A, B, DEG2RAD(ANGLE))
                IF (C .GT. MAX_NUM .OR. MOD(C, 1.) .NE. 0) THEN
                    CYCLE
                END IF

                CANDIDATE(1) = A
                CANDIDATE(2) = B
                CANDIDATE(3) = C
                IF (.NOT. CONTAINS_ARR(CANDIDATES, CANDIDATE)) THEN
                    COUNTER = COUNTER + 1
                    CALL APPEND(CANDIDATES, CANDIDATE(1))
                    CALL APPEND(CANDIDATES, CANDIDATE(2))
                    CALL APPEND(CANDIDATES, CANDIDATE(3))

                    IF (PRINT_RESULTS) THEN
                        WRITE(*,'(A,I0,A,I0,A,I0,A)') " (", CANDIDATE(1), ", ", CANDIDATE(2), ", ", CANDIDATE(3), ")"
                    END IF
                END IF
            END DO
        END DO
    END FUNCTION COSINE_TRIPLES

END MODULE LAW_OF_COSINES

! Program prints the cosine triples for the angles 90, 60 and 120 degrees
! by using the cosine rule to find the third side of each candidate and
! checking that this is an integer. Candidates are appended to an array
! after the sides have been sorted into ascending order
! the array is repeatedly checked to ensure there are no duplicates.
PROGRAM LOC
    USE LAW_OF_COSINES

    REAL(8), DIMENSION(3) :: TEST_ANGLES = (/90., 60., 120./)
    INTEGER :: I, COUNTER

    DO I = 1,SIZE(TEST_ANGLES)
        WRITE(*, '(F0.0, A)') TEST_ANGLES(I), " degree triangles: "
        COUNTER = COSINE_TRIPLES(1, 13, TEST_ANGLES(I), .TRUE.)
        WRITE(*,'(A, I0)') "TOTAL: ", COUNTER
        WRITE(*,*) NEW_LINE('A')
    END DO

END PROGRAM LOC
