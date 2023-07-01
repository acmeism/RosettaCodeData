PROC odd even sort = (REF []DATA a)VOID: (
  FOR offset FROM 0 DO
    BOOL swapped := FALSE;
    FOR i FROM LWB a + offset TO UPB a - 1 - offset DO
      IF a[ i ] > a[ i + 1 ] THEN # test whether the two elements are in the wrong order #
        swap( a[ i ], a[ i + 1 ] ); # let the two elements change places #
        swapped := TRUE
      FI
    OD;
  # we can exit the outer loop here if no swaps occurred. #
    IF NOT swapped THEN break do od loop FI;
    swapped := FALSE;
    FOR i FROM UPB a - 1 - offset - 1 BY - 1 TO LWB a + offset DO
      IF a[ i ] > a[ i + 1 ] THEN
        swap( a[ i ], a[ i + 1 ] );
        swapped := TRUE
      FI
    OD;
  # if no elements have been swapped, then the list is sorted #
    IF NOT swapped THEN break do od loop FI;
  OD;
  break do od loop: SKIP
);
