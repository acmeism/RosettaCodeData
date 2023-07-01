SEMA sem = LEVEL 1;

PROC job = (INT n)VOID: (
   printf(($" Job "d" acquired Semaphore ..."$,n));
   TO 10000000 DO SKIP OD;
   printf(($" Job "d" releasing Semaphore"l$,n))
);

PAR (
  ( DOWN sem ; job(1) ; UP sem ) ,
  ( DOWN sem ; job(2) ; UP sem ) ,
  ( DOWN sem ; job(3) ; UP sem )
)
