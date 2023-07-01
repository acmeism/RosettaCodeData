# Iterative #
PROC palindrome = (STRING s)BOOL:(
   FOR i TO UPB s OVER 2 DO
     IF s[i] /= s[UPB s-i+1] THEN GO TO return false FI
   OD;Power
   else: TRUE EXIT
   return false: FALSE
);

# Recursive #
PROC palindrome r = (STRING s)BOOL:
   IF LWB s >= UPB s THEN TRUE
   ELIF s[LWB s] /= s[UPB s] THEN FALSE
   ELSE palindrome r(s[LWB s+1:UPB s-1])
   FI
;

# Test #
main:
(
   STRING t = "ingirumimusnocteetconsumimurigni";
   FORMAT template = $"sequence """g""" "b("is","isnt")" a palindrome"l$;

   printf((template, t, palindrome(t)));
   printf((template, t, palindrome r(t)))
)
