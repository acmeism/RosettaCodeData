PROC stem and leaf plot = ([]INT data)VOID:
  BEGIN
    # get lowest and highest stem values #
    INT min stem := data[LWB data] % 10,
        max stem := data[LWB data] % 10;
    FOR i FROM LWB data + 1 TO UPB data DO
      INT stem := data[i] % 10;
      IF min stem > stem THEN min stem := stem FI;
      IF max stem < stem THEN max stem := stem FI
    OD;
    # this array will store the amount of leaves per stem: #
    [min stem : max stem, 0:9]INT stems;
    FOR i FROM LWB stems TO UPB stems DO
      stems[i,] := []INT((0,0,0,0,0,0,0,0,0,0))[@0]
    OD;
    # fill the array #
    FOR i FROM LWB data TO UPB data DO
      stems[data[i] % 10, data[i] %* 10] +:= 1
    OD;
    # print the histogram #
    FOR i FROM LWB stems TO UPB stems DO
      print((whole(i, -4), "| "));
      FOR j FROM 0 TO 9 DO
        print(REPR (j + ABS "0") * stems[i,j])
      OD;
      print(newline)
    OD
  END;

[]INT data = (12, 127, 28, 42, 39, 113, 42, 18, 44, 118, 44,
              37, 113, 124, 37, 48, 127, 36, 29, 31, 125,
              139, 131, 115, 105, 132, 104, 123, 35, 113,
              122, 42, 117, 119, 58, 109, 23, 105, 63, 27,
              44, 105, 99, 41, 128, 121, 116, 125, 32, 61,
              37, 127, 29, 113, 121, 58, 114, 126, 53, 114,
              96, 25, 109, 7, 31, 141, 46, 13, 27, 43, 117,
              116, 27, 7, 68, 40, 31, 115, 124, 42, 128, 52,
              71, 118, 117, 38, 27, 106, 33, 117, 116, 111,
              40, 119, 47, 105, 57, 122, 109, 124, 115, 43,
              120, 43, 27, 27, 18, 28, 48, 125, 107, 114, 34,
              133, 45, 120, 30, 127, 31, 116, 146);

stem and leaf plot(data)
