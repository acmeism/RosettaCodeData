PROC factorial = (INT n)LONG LONG INT:
  CASE n+1 IN
    1,1,2,6,24,120,720 # a brief lookup #
  OUT
    n*factorial(n-1)
  ESAC
; ~
