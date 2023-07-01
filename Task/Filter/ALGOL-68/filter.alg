MODE TYPE = INT;

PROC select = ([]TYPE from, PROC(TYPE)BOOL where)[]TYPE:
BEGIN
  FLEX[0]TYPE result;
  FOR key FROM LWB from TO UPB from DO
    IF where(from[key]) THEN
      [UPB result+1]TYPE new result;
      new result[:UPB result] := result;
      new result[UPB new result] := from[key];
      result := new result
    FI
  OD;
  result
END;

[]TYPE from values = (1,2,3,4,5,6,7,8,9,10);
PROC where even = (TYPE value)BOOL: NOT ODD value;

print((select(from values, where even), new line));

# Or as a simple one line query #
print((select((1,4,9,16,25,36,49,64,81,100), (TYPE x)BOOL: NOT ODD x ), new line))
