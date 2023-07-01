       ...
       PROCEDURE DIVISION.
           DISPLAY "Str  : " Str
           MOVE FUNCTION CONCATENATE(Str, " World!") TO Str2
           DISPLAY "Str2 : " Str2

           GOBACK
           .
