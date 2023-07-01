REAL :: n=100, open=1, door(n)

door = 1 - open ! = closed
DO i = 1, n
  DO j = i, n, i
    door(j) = open - door(j)
  ENDDO
ENDDO
DLG(Text=door, TItle=SUM(door)//" doors open")
