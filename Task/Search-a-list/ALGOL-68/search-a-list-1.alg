 FORMAT hay stack := $c("Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo")$;

 FILE needle exception; STRING ref needle;
 associate(needle exception, ref needle);

 PROC index = (FORMAT haystack, REF STRING needle)INT:(
   INT out;
   ref needle := needle;
   getf(needle exception,(haystack, out));
   out
 );

 test:(
   []STRING needles = ("Washington","Bush");
   FOR i TO UPB needles DO
     STRING needle := needles[i];
     on value error(needle exception, (REF FILE f)BOOL: value error);
       printf(($d" "gl$,index(hay stack, needle), needle));
       end on value error;
     value error:
       printf(($g" "gl$,needle, "is not in haystack"));
     end on value error: reset(needle exception)
   OD
 )
