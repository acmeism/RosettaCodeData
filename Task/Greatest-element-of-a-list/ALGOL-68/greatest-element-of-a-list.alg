# substitute any array type with a scalar element #
MODE FLT = REAL;

# create an exception for the case of an empty array #
PROC raise empty array = VOID:(
  GO TO except empty array
);

PROC max = ([]FLT item)FLT:
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

test:(
  []FLT buf = (-275.0, -111.19, 0.0, -1234568.0, pi, -pi);
  print((max(buf),new line)) EXIT
  except empty array:
    SKIP
)
