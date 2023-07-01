 PROC call back proc = (INT location, INT value)VOID:
 (
   printf(($"array["g"] = "gl$, location, value))
 );

 PROC map = (REF[]INT array, PROC (INT,INT)VOID call back)VOID:
 (
   FOR i FROM LWB array TO UPB array DO
      call back(i, array[i])
   OD
 );

 main:
 (
   [4]INT array := ( 1, 4, 9, 16 );
   map(array, call back proc)
 )
