PROGRAM EXAMPLE
  IMPLICIT NONE

  TYPE Pair
    CHARACTER(6) :: name
    CHARACTER(1) :: value
  END TYPE Pair

  TYPE(Pair) :: rcc(10), temp
  INTEGER :: i, j

  rcc(1) = Pair("Black", "0")
  rcc(2) = Pair("Brown", "1")
  rcc(3) = Pair("Red", "2")
  rcc(4) = Pair("Orange", "3")
  rcc(5) = Pair("Yellow", "4")
  rcc(6) = Pair("Green", "5")
  rcc(7) = Pair("Blue", "6")
  rcc(8) = Pair("Violet", "7")
  rcc(9) = Pair("Grey", "8")
  rcc(10) = Pair("White", "9")

  DO i = 2, SIZE(rcc)
     j = i - 1
     temp = rcc(i)
        DO WHILE (j>=1 .AND. LGT(rcc(j)%name, temp%name))
           rcc(j+1) = rcc(j)
           j = j - 1
        END DO
     rcc(j+1) = temp
  END DO

  WRITE (*,"(2A6)") rcc

END PROGRAM EXAMPLE
