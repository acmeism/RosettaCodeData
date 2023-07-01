PROGRAM DATE

  IMPLICIT NONE

  INTEGER :: dateinfo(8), day
  CHARACTER(9) :: month, dayname

  CALL DATE_AND_TIME(VALUES=dateinfo)
  SELECT CASE(dateinfo(2))
    CASE(1)
      month = "January"
    CASE(2)
      month = "February"
    CASE(3)
      month = "March"
    CASE(4)
      month = "April"
    CASE(5)
      month = "May"
    CASE(6)
      month = "June"
    CASE(7)
      month = "July"
    CASE(8)
      month = "August"
    CASE(9)
      month = "September"
    CASE(10)
      month = "October"
    CASE(11)
      month = "November"
    CASE(12)
     month = "December"
  END SELECT

  day = Day_of_week(dateinfo(3), dateinfo(2), dateinfo(1))

  SELECT CASE(day)
    CASE(0)
      dayname = "Saturday"
    CASE(1)
      dayname = "Sunday"
    CASE(2)
      dayname = "Monday"
    CASE(3)
      dayname = "Tuesday"
    CASE(4)
      dayname = "Wednesday"
    CASE(5)
      dayname = "Thursday"
    CASE(6)
      dayname = "Friday"
  END SELECT

  WRITE(*,"(I0,A,I0,A,I0)") dateinfo(1),"-", dateinfo(2),"-", dateinfo(3)
  WRITE(*,"(4(A),I0,A,I0)") trim(dayname), ", ", trim(month), " ", dateinfo(3), ", ", dateinfo(1)

CONTAINS

  FUNCTION Day_of_week(d, m, y)
    INTEGER :: Day_of_week, j, k
    INTEGER, INTENT(IN) :: d, m, y

    j = y / 100
    k = MOD(y, 100)
    Day_of_week = MOD(d + (m+1)*26/10 + k + k/4 + j/4 + 5*j, 7)
  END FUNCTION Day_of_week

END PROGRAM DATE
