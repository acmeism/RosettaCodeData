MODE DATA = REF CHAR;

PROC in place selection sort = (REF[]DATA a)VOID:
BEGIN
   INT min;
   DATA temp;
   FOR i FROM LWB a TO UPB a DO
      min := i;
      FOR j FROM i + 1 TO UPB a DO
         IF a [min] > a [j] THEN
            min := j
         FI
      OD;
      IF min /= i THEN
         temp    := a [i];
         a [i]   := a [min];
         a [min] := temp
      FI
   OD
END # in place selection sort #;

[32]CHAR data := "big fjords vex quick waltz nymph";
[UPB data]DATA ref data;  FOR i TO UPB data DO ref data[i] := data[i] OD;
in place selection sort(ref data);
FOR i TO UPB ref data DO print(ref data[i]) OD; print(new line);
print((data))
