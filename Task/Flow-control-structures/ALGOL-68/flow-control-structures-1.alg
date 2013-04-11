(
   FOR j TO 1000 DO
     FOR i TO j-1 DO
       IF random > 0.999 THEN
         printf(($"Exited when: i="g(0)", j="g(0)l$,i,j));
         done
       FI
       # etc. #
     OD
   OD;
 done: EMPTY
);
