BEGIN
MODE FLT = REAL; # substitute any array type with ">" defined #

PROC max = ([]FLT item, PROC VOID raise empty array)FLT:
BEGIN
   IF LWB item > UPB item THEN
      raise empty array; SKIP
   ELSE
     FLT max element := item[LWB item];

     FOR i FROM LWB item + 1 TO UPB item DO
       IF item[i] > max element THEN
         max element := item[i]
       FI
     OD;
     max element
   FI
END # max #;

#test#(
  []FLT buf = (-275.0, -111.19, 0.0, -1234568.0, pi, -pi);
  # handle an exception for the case of an empty array #
  PROC have empty array = VOID:print(("empty array", newline));

  print((max(buf,have empty array),new line))
)
END
