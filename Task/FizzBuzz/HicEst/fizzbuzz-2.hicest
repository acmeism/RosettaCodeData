CHARACTER string*8

DO i = 1, 100
  string = " "
  IF( MOD(i, 3) == 0 ) string = "Fizz"
  IF( MOD(i, 5) == 0 ) string = TRIM(string) // "Buzz"
  IF( string == " ") WRITE(Text=string) i
  WRITE() string
ENDDO
