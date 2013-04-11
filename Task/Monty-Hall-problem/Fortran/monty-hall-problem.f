PROGRAM MONTYHALL

  IMPLICIT NONE

  INTEGER, PARAMETER :: trials = 10000
  INTEGER :: i, choice, prize, remaining, show, staycount = 0, switchcount = 0
  LOGICAL :: door(3)
  REAL :: rnum

  CALL RANDOM_SEED
  DO i = 1, trials
     door = .FALSE.
     CALL RANDOM_NUMBER(rnum)
     prize = INT(3*rnum) + 1
     door(prize) = .TRUE.              ! place car behind random door

     CALL RANDOM_NUMBER(rnum)
     choice = INT(3*rnum) + 1          ! choose a door

     DO
        CALL RANDOM_NUMBER(rnum)
        show = INT(3*rnum) + 1
        IF (show /= choice .AND. show /= prize) EXIT       ! Reveal a goat
     END DO

     SELECT CASE(choice+show)          ! Calculate remaining door index
       CASE(3)
          remaining = 3
       CASE(4)
          remaining = 2
       CASE(5)
          remaining = 1
     END SELECT

     IF (door(choice)) THEN           ! You win by staying with your original choice
        staycount = staycount + 1
     ELSE IF (door(remaining)) THEN   ! You win by switching to other door
        switchcount = switchcount + 1
     END IF

  END DO

  WRITE(*, "(A,F6.2,A)") "Chance of winning by not switching is", real(staycount)/trials*100, "%"
  WRITE(*, "(A,F6.2,A)") "Chance of winning by switching is", real(switchcount)/trials*100, "%"

END PROGRAM MONTYHALL
