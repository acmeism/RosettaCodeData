 []STRING hay stack = ("Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo");

 PROC index = ([]STRING hay stack, STRING needle)INT:(
   INT index;
   FOR i FROM LWB hay stack TO UPB hay stack DO
     index := i;
     IF hay stack[index] = needle THEN
       found
     FI
   OD;
   else:
     LWB hay stack - 1
   EXIT
   found:
     index
 );
 test:(
   []STRING needles = ("Washington","Bush");
   FOR i TO UPB needles DO
     STRING needle := needles[i];
     INT result = index(hay stack, needle);
     IF result >= LWB hay stack THEN
       printf(($d" "gl$, result, needle))
     ELSE
       printf(($g" "gl$,needle, "is not in haystack"))
     FI
   OD
 )
