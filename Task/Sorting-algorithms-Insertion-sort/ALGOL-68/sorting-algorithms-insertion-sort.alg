MODE DATA = REF CHAR;

PROC in place insertion sort = (REF[]DATA item)VOID:
BEGIN
   INT first := LWB item;
   INT last  := UPB item;
   INT j;
   DATA value;
   FOR i FROM first + 1 TO last DO
      value := item[i];
      j := i - 1;
   #  WHILE j >= LWB item AND j <= UPB item ANDF item[j] > value DO // example of ANDF extension #
      WHILE ( j >= LWB item AND j <= UPB item | item[j]>value | FALSE ) DO # no extension! #
         item[j + 1] := item[j];
         j -:=  1
      OD;
      item[j + 1] := value
   OD
END # in place insertion sort #;

[32]CHAR data := "big fjords vex quick waltz nymph";
[UPB data]DATA ref data;  FOR i TO UPB data DO ref data[i] := data[i] OD;
in place insertion sort(ref data);
FOR i TO UPB ref data DO print(ref data[i]) OD; print(new line);
print((data))
