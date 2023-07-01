SUBROUTINE SHUFFLE_ARRAY(INT_ARRAY)
    ! Takes an input array and shuffles the elements by swapping them
    ! in pairs in turn 10 times
    IMPLICIT NONE

    INTEGER, DIMENSION(100), INTENT(INOUT) :: INT_ARRAY
    INTEGER, PARAMETER :: N_PASSES = 10
    ! Local Variables

    INTEGER :: TEMP_1, TEMP_2   ! Temporaries for swapping elements
    INTEGER :: I, J, PASS       ! Indices variables
    REAL :: R                   ! Randomly generator value

    CALL RANDOM_SEED()  ! Seed the random number generator

    DO PASS=1, N_PASSES
        DO I=1, SIZE(INT_ARRAY)

            ! Get a random index to swap with
            CALL RANDOM_NUMBER(R)
            J = CEILING(R*SIZE(INT_ARRAY))

            ! In case generated index value
            ! exceeds array size
            DO WHILE (J > SIZE(INT_ARRAY))
                J = CEILING(R*SIZE(INT_ARRAY))
            END DO

            !  Swap the two elements
            TEMP_1 = INT_ARRAY(I)
            TEMP_2 = INT_ARRAY(J)
            INT_ARRAY(I) = TEMP_2
            INT_ARRAY(J) = TEMP_1
        ENDDO
    ENDDO
END SUBROUTINE SHUFFLE_ARRAY

SUBROUTINE RUN_RANDOM(N_ROUNDS)
    ! Run the 100 prisoner puzzle simulation N_ROUNDS times
    ! in the scenario where each prisoner selects a drawer at random
    IMPLICIT NONE

    INTEGER, INTENT(IN) :: N_ROUNDS ! Number of simulations to run in total

    INTEGER :: ROUND, PRISONER, CHOICE, I       ! Iteration variables
    INTEGER :: N_SUCCESSES                      ! Number of successful trials
    REAL(8) :: TOTAL                            ! Total number of trials as real
    LOGICAL :: NUM_FOUND = .FALSE.              ! Prisoner has found their number

    INTEGER, DIMENSION(100) :: CARDS, CHOICES   ! Arrays representing card allocations
                                                ! to draws and drawer choice order

    ! Both cards and choices are randomly assigned.
    ! This being the drawer (allocation represented by index),
    ! and what drawer to pick for Nth/50 choice
    ! (take first 50 elements of 100 element array)
    CARDS = (/(I, I=1, 100, 1)/)
    CHOICES = (/(I, I=1, 100, 1)/)

    N_SUCCESSES = 0
    TOTAL = REAL(N_ROUNDS)

    ! Run the simulation for N_ROUNDS rounds
    ! when a prisoner fails to find their number
    ! after 50 trials, set that simulation to fail
    ! and start the next round
    ROUNDS_LOOP: DO ROUND=1, N_ROUNDS
        CALL SHUFFLE_ARRAY(CARDS)
        PRISONERS_LOOP: DO PRISONER=1, 100
            NUM_FOUND = .FALSE.
            CALL SHUFFLE_ARRAY(CHOICES)
            CHOICE_LOOP: DO CHOICE=1, 50
                IF(CARDS(CHOICE) == PRISONER) THEN
                    NUM_FOUND = .TRUE.
                    EXIT CHOICE_LOOP
                ENDIF
            ENDDO CHOICE_LOOP
            IF(.NOT. NUM_FOUND) THEN
                EXIT PRISONERS_LOOP
            ENDIF
        ENDDO PRISONERS_LOOP
        IF(NUM_FOUND) THEN
            N_SUCCESSES = N_SUCCESSES + 1
        ENDIF
    ENDDO ROUNDS_LOOP

    WRITE(*, '(A, F0.3, A)') "Random drawer selection method success rate: ", &
        100*N_SUCCESSES/TOTAL, "%"

END SUBROUTINE RUN_RANDOM

SUBROUTINE RUN_OPTIMAL(N_ROUNDS)
    ! Run the 100 prisoner puzzle simulation N_ROUNDS times in the scenario
    ! where each prisoner selects firstly the drawer with their number and then
    ! subsequently the drawer matching the number of the card present
    ! within that current drawer
    IMPLICIT NONE

    INTEGER, INTENT(IN) :: N_ROUNDS

    INTEGER :: ROUND, PRISONER, CHOICE, I   ! Iteration variables
    INTEGER :: CURRENT_DRAW                 ! ID of the current draw
    INTEGER :: N_SUCCESSES                  ! Number of successful trials
    REAL(8) :: TOTAL                        ! Total number of trials as real
    LOGICAL :: NUM_FOUND = .FALSE.          ! Prisoner has found their number
    INTEGER, DIMENSION(100) :: CARDS        ! Array representing card allocations

    ! Cards are randomly assigned to a drawer
    ! (allocation represented by index),
    CARDS = (/(I, I=1, 100, 1)/)

    N_SUCCESSES = 0
    TOTAL = REAL(N_ROUNDS)

    ! Run the simulation for N_ROUNDS rounds
    ! when a prisoner fails to find their number
    ! after 50 trials, set that simulation to fail
    ! and start the next round
    ROUNDS_LOOP: DO ROUND=1, N_ROUNDS
        CARDS = (/(I, I=1, 100, 1)/)
        CALL SHUFFLE_ARRAY(CARDS)
        PRISONERS_LOOP: DO PRISONER=1, 100
            CURRENT_DRAW = PRISONER
            NUM_FOUND = .FALSE.
            CHOICE_LOOP: DO CHOICE=1, 50
                IF(CARDS(CURRENT_DRAW) == PRISONER) THEN
                    NUM_FOUND = .TRUE.
                    EXIT CHOICE_LOOP
                ELSE
                    CURRENT_DRAW = CARDS(CURRENT_DRAW)
                ENDIF
            ENDDO CHOICE_LOOP
            IF(.NOT. NUM_FOUND) THEN
                EXIT PRISONERS_LOOP
            ENDIF
        ENDDO PRISONERS_LOOP
        IF(NUM_FOUND) THEN
            N_SUCCESSES = N_SUCCESSES + 1
        ENDIF
    ENDDO ROUNDS_LOOP
    WRITE(*, '(A, F0.3, A)') "Optimal drawer selection method success rate: ", &
        100*N_SUCCESSES/TOTAL, "%"

END SUBROUTINE RUN_OPTIMAL

PROGRAM HUNDRED_PRISONERS
    ! Run the two scenarios for the 100 prisoners puzzle of random choice
    ! and optimal choice (choice based on drawer contents)
    IMPLICIT NONE
    INTEGER, PARAMETER :: N_ROUNDS = 50000
    WRITE(*,'(A, I0, A)') "Running simulation for ", N_ROUNDS, " trials..."
    CALL RUN_RANDOM(N_ROUNDS)
    CALL RUN_OPTIMAL(N_ROUNDS)
END PROGRAM HUNDRED_PRISONERS
