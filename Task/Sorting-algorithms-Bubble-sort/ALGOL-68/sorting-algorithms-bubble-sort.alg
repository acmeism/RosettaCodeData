MODE DATA = INT;
PROC swap = (REF[]DATA slice)VOID:
(
  DATA tmp = slice[1];
  slice[1] := slice[2];
  slice[2] := tmp
);

PROC sort = (REF[]DATA array)VOID:
(
  BOOL sorted;
  INT shrinkage := 0;
  FOR size FROM UPB array - 1 BY -1 WHILE
    sorted := TRUE;
    shrinkage +:= 1;
    FOR i FROM LWB array TO size DO
      IF array[i+1] < array[i] THEN
        swap(array[i:i+1]);
        sorted := FALSE
      FI
    OD;
    NOT sorted
  DO SKIP OD
);

main:(
  [10]INT random := (1,6,3,5,2,9,8,4,7,0);

  printf(($"Before: "10(g(3))l$,random));
  sort(random);
  printf(($"After: "10(g(3))l$,random))
)
