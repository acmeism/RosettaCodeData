PROGRAM POINT_WITHIN_TRIANGLE

IMPLICIT NONE

REAL (KIND = SELECTED_REAL_KIND (8)) px, py, ax, ay, bx, by, cx, cy

px = 0.0
py = 0.0
ax = 1.5
ay = 2.4
bx = 5.1
by = -3.1
cx = -3.8
cy = 1.2

IF (IS_P_IN_ABC (px, py, ax, ay, bx, by, cx, cy)) THEN

    WRITE (*, *) 'Point (', px, ', ', py, ') is within triangle &
        [(', ax, ', ', ay,'), (', bx, ', ', by, '), (', cx, ', ', cy, ')].'

  ELSE

    WRITE (*, *) 'Point (', px, ', ', py, ') is not within triangle &
        [(', ax, ', ', ay,'), (', bx, ', ', by, '), (', cx, ', ', cy, ')].'

END IF

CONTAINS

  !Provide xy values of points P, A, B, C, respectively.
  LOGICAL FUNCTION IS_P_IN_ABC (px, py, ax, ay, bx, by, cx, cy)

    REAL (KIND = SELECTED_REAL_KIND (8)), INTENT (IN) :: px, py, ax, ay, bx, by, cx, cy
    REAL (KIND = SELECTED_REAL_KIND (8)) :: vabx, vaby, vacx, vacy, a, b

    vabx = bx - ax
    vaby = by - ay
    vacx = cx - ax
    vacy = cy - ay

    a = ((px * vacy - py * vacx) - (ax * vacy - ay * vacx)) / &
        (vabx * vacy - vaby * vacx)
    b = -((px * vaby - py * vabx) - (ax * vaby - ay * vabx)) / &
        (vabx * vacy - vaby * vacx)

    IF ((a .GT. 0) .AND. (b .GT. 0) .AND. (a + b < 1)) THEN

        IS_P_IN_ABC = .TRUE.

      ELSE

        IS_P_IN_ABC = .FALSE.

    END IF

  END FUNCTION IS_P_IN_ABC

END PROGRAM POINT_WITHIN_TRIANGLE
