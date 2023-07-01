MODE DATA = CHAR;
PROC swap = (REF DATA a,b)VOID:(
  DATA tmp:=a; a:=b; b:=tmp
);

PROC cocktail sort = (REF[]DATA a)VOID: (
  WHILE
    BOOL swapped := FALSE;
    FOR i FROM LWB a TO UPB a - 1 DO
      IF a[ i ] > a[ i + 1 ] THEN # test whether the two elements are in the wrong order #
        swap( a[ i ], a[ i + 1 ] ); # let the two elements change places #
        swapped := TRUE
      FI
    OD;
    IF NOT swapped THEN
      # we can exit the outer loop here if no swaps occurred. #
      break do while loop
    FI;
    swapped := FALSE;
    FOR i FROM UPB a - 1 TO LWB a DO
      IF a[ i ] > a[ i + 1 ] THEN
        swap( a[ i ], a[ i + 1 ] );
        swapped := TRUE
      FI
    OD;
# WHILE # swapped # if no elements have been swapped, then the list is sorted #
  DO SKIP OD;
  break do while loop: SKIP
);

[32]CHAR data := "big fjords vex quick waltz nymph";
cocktail sort(data);
print(data)
