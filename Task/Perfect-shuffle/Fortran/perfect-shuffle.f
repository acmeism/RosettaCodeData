MODULE PERFECT_SHUFFLE
     IMPLICIT NONE

     CONTAINS

     ! Shuffle the deck/array of integers
     FUNCTION SHUFFLE(NUM_ARR)
          INTEGER, DIMENSION(:), INTENT(IN) :: NUM_ARR
          INTEGER, DIMENSION(SIZE(NUM_ARR)) :: SHUFFLE
          INTEGER :: I, IDX

          IF (MOD(SIZE(NUM_ARR), 2) .NE. 0) THEN
              WRITE(*,*) "ERROR: SIZE OF DECK MUST BE EVEN NUMBER"
              CALL EXIT(1)
          END IF

          IDX = 1

          DO I=1, SIZE(NUM_ARR)/2
              SHUFFLE(IDX) = NUM_ARR(I)
              SHUFFLE(IDX+1) = NUM_ARR(SIZE(NUM_ARR)/2+I)
              IDX = IDX + 2
          END DO

    END FUNCTION SHUFFLE

    ! Compare two arrays element by element
    FUNCTION COMPARE_ARRAYS(ARRAY_1, ARRAY_2)
        INTEGER, DIMENSION(:) :: ARRAY_1, ARRAY_2
        LOGICAL :: COMPARE_ARRAYS
        INTEGER :: I

        DO I=1,SIZE(ARRAY_1)
            IF (ARRAY_1(I) .NE. ARRAY_2(I)) THEN
                COMPARE_ARRAYS = .FALSE.
                RETURN
            END IF
        END DO

        COMPARE_ARRAYS = .TRUE.
    END FUNCTION COMPARE_ARRAYS

    ! Generate a deck/array of consecutive integers
    FUNCTION GEN_DECK(DECK_SIZE)
        INTEGER, INTENT(IN) :: DECK_SIZE
        INTEGER, DIMENSION(DECK_SIZE) :: GEN_DECK
        INTEGER :: I

        GEN_DECK = (/(I, I=1,DECK_SIZE)/)
    END FUNCTION GEN_DECK
END MODULE PERFECT_SHUFFLE

! Program to demonstrate the perfect shuffle algorithm
! for various deck sizes
PROGRAM DEMO_PERFECT_SHUFFLE
    USE PERFECT_SHUFFLE
    IMPLICIT NONE

    INTEGER, PARAMETER, DIMENSION(7) :: DECK_SIZES = (/8, 24, 52, 100, 1020, 1024, 10000/)
    INTEGER, DIMENSION(:), ALLOCATABLE :: DECK, SHUFFLED
    INTEGER :: I, COUNTER

    WRITE(*,'(A, A, A)') "input (deck size)", " | ", "output (number of shuffles required)"
    WRITE(*,*) REPEAT("-", 55)

    DO I=1, SIZE(DECK_SIZES)
        IF (I .GT. 1) THEN
            DEALLOCATE(DECK)
            DEALLOCATE(SHUFFLED)
        END IF
        ALLOCATE(DECK(DECK_SIZES(I)))
        ALLOCATE(SHUFFLED(DECK_SIZES(I)))
        DECK = GEN_DECK(DECK_SIZES(I))
        SHUFFLED = SHUFFLE(DECK)
        COUNTER = 1
        DO WHILE (.NOT. COMPARE_ARRAYS(DECK, SHUFFLED))
            SHUFFLED = SHUFFLE(SHUFFLED)
            COUNTER = COUNTER + 1
        END DO

        WRITE(*,'(I17, A, I35)') DECK_SIZES(I), " | ", COUNTER
   END DO
END PROGRAM DEMO_PERFECT_SHUFFLE
