PROC counting sort mm = (REF[]INT array, INT min, max)VOID:
(
  INT z := LWB array - 1;
  [min:max]INT count;

  FOR i FROM LWB count TO UPB count DO count[i] := 0 OD;
  FOR i TO UPB array DO count[ array[i] ]+:=1 OD;

  FOR i FROM LWB count TO UPB count DO
    FOR j TO count[i] DO array[z+:=1] := i OD
  OD
);

PROC counting sort = (REF[]INT array)VOID:
(
  INT min, max;
  min := max := array[LWB array];

  FOR i FROM LWB array + 1 TO UPB array DO
    IF array[i] < min THEN
      min := array[i]
    ELIF array[i] > max THEN
      max := array[i]
    FI
  OD
);

# Testing (we suppose the oldest human being is less than 140 years old). #

INT n = 100;
INT min age = 0, max age = 140;
main:
(
  [n]INT ages;

  FOR i TO UPB ages DO ages[i] := ENTIER (random * ( max age + 1 ) ) OD;
  counting sort mm(ages, min age, max age);
  FOR i TO UPB ages DO print((" ", whole(ages[i],0))) OD;
  print(new line)
)
