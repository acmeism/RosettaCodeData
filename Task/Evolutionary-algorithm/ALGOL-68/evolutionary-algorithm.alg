STRING target := "METHINKS IT IS LIKE A WEASEL";

PROC fitness = (STRING tstrg)REAL:
(
   INT sum := 0;
   FOR i FROM LWB tstrg TO UPB tstrg DO
      sum +:= ABS(ABS target[i] - ABS tstrg[i])
   OD;
   # fitness := # 100.0*exp(-sum/10.0)
);

PROC rand char = CHAR:
(
   #STATIC# []CHAR ucchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ";
   # rand char := # ucchars[ENTIER (random*UPB ucchars)+1]
);

PROC mutate = (REF STRING kid, parent, REAL mutate rate)VOID:
(
   FOR i FROM LWB parent TO UPB parent DO
      kid[i] := IF random < mutate rate THEN rand char ELSE parent[i] FI
   OD
);

PROC kewe = ( STRING parent, INT iters, REAL fits, REAL mrate)VOID:
(
   printf(($"#"4d" fitness: "g(-6,2)"% "g(-6,4)" '"g"'"l$, iters, fits, mrate, parent))
);

PROC evolve = VOID:
(
   FLEX[UPB target]CHAR parent;
   REAL fits;
   [100]FLEX[UPB target]CHAR kid;
   INT iters := 0;
   kid[LWB kid] := LOC[UPB target]CHAR;
   REAL mutate rate = 0.05;

   #  initialize  #
   FOR i FROM LWB parent TO UPB parent DO
      parent[i] := rand char
   OD;

   fits := fitness(parent);
   WHILE
      INT j;
      REAL kf;
      FOR j FROM LWB kid TO UPB kid DO
         mutate(kid[j], parent, mutate rate)
      OD;
      FOR j FROM LWB kid TO UPB kid DO
         kf := fitness(kid[j]);
         IF fits < kf THEN
            fits := kf;
            parent := kid[j]
         FI
      OD;
      fits < 100.0
   DO
      kewe( parent, iters, fits, mutate rate );
      iters+:=1
   OD;
   kewe( parent, iters, fits, mutate rate )
);

main:
(
   evolve
)
