   split:{1_'(&x=y)_ x:y,x}

   g: ("ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB")
   g,:(" CDBA CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB")
   p: split[g;" "];

   / All permutations of "ABCD"
   perm:{:[1<x;,/(>:'(x,x)#1,x#0)[;0,'1+_f x-1];,!x]}
   p2:a@(perm(#a:"ABCD"));

   / Which permutations in p are there in p2?
   p2 _lin p
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1

   / Invert the result
   ~p2 _lin p
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0

   / It's the 20th permutation that is missing
   &~p2 _lin p
,20

   p2@&~p2 _lin p
"DBAC"
