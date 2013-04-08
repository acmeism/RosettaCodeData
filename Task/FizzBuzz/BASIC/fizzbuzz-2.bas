FOR A = 1 TO 100
   OUT$ = ""

   IF A MOD 3 = 0 THEN
      OUT$ = "Fizz"
   END IF

   IF A MOD 5 = 0 THEN
      OUT$ = OUT$ + "Buzz"
   END IF

   IF OUT$ = "" THEN
      OUT$ = STR$(A)
   END IF

   PRINT OUT$
NEXT A
