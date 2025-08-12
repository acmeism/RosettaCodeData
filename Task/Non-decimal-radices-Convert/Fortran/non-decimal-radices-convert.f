MODULE Conversion
  IMPLICIT NONE
  CHARACTER(36) :: alphanum = "0123456789abcdefghijklmnopqrstuvwxyz"

  CONTAINS

  FUNCTION ToDecimal(base, instr)
    INTEGER :: ToDecimal
    INTEGER :: length, i, n, base
    CHARACTER(*) :: instr

    ToDecimal = 0
    length = LEN(instr)
    DO i = 1, length
      n = INDEX(alphanum, instr(i:i)) - 1
      n = n * base**(length-i)
      Todecimal = ToDecimal + n
    END DO
  END FUNCTION ToDecimal

  FUNCTION ToBase(base, number_in)
    CHARACTER(31) :: ToBase
    INTEGER :: base, number_in, number, i, rem

    number = number_in
    ToBase = "                               "
    DO i = 31, 1, -1
      IF(number < base) THEN
        ToBase(i:i) = alphanum(number+1:number+1)
        EXIT
      END IF
      rem = MOD(number, base)
      ToBase(i:i) = alphanum(rem+1:rem+1)
      number = number / base
    END DO
    ToBase = ADJUSTL(ToBase)
  END FUNCTION ToBase

END MODULE Conversion

PROGRAM Base_Convert
  USE Conversion

  WRITE (*,*) ToDecimal(16, "1a")
  WRITE (*,*) ToBase(16, 26)

END PROGRAM
