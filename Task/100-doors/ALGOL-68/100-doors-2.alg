PROC doors optimised = ( INT limit )VOID:
  FOR i TO limit DO
    REAL num := sqrt(i);
    printf(($g" is "gl$,i,(ENTIER num = num |"opened"|"closed") ))
  OD
;
doors optimised(limit)
