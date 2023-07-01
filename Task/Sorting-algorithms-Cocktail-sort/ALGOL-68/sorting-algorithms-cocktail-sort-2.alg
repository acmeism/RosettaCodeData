MODE DATA = REF CHAR;
PROC swap = (REF DATA a,b)VOID:(
  DATA tmp:=a; a:=b; b:=tmp
);

PROC (REF[]DATA a)VOID cocktail sort;

[32]CHAR data := "big fjords vex quick waltz nymph";
[UPB data]DATA ref data;  FOR i TO UPB data DO ref data[i] := data[i] OD;
cocktail sort(ref data);
FOR i TO UPB ref data DO print(ref data[i]) OD; print(new line);
print((data))
