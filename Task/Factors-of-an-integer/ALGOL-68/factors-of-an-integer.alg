MODE YIELDINT = PROC(INT)VOID;

PROC gen factors = (INT n, YIELDINT yield)VOID: (
  FOR i FROM 1 TO ENTIER sqrt(n) DO
    IF n MOD i = 0 THEN
      yield(i);
      INT other = n OVER i;
      IF i NE other THEN yield(n OVER i) FI
    FI
  OD
);

[]INT nums2factor = (45, 53, 64);

FOR i TO UPB nums2factor DO
  INT num = nums2factor[i];
  STRING sep := ": ";
  print(num);
# FOR INT j IN # gen factors(num, # ) DO ( #
##   (INT j)VOID:(
       print((sep,whole(j,0)));
       sep:=", "
# OD # ));
  print(new line)
OD
