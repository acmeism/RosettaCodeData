LOOPMULT
 N A,B,C,D,%
 S A="a,b,c,d"
 S B="A,B,C,D"
 S C="1,2,3"
 S D=","
 F %=1:1:$L(A,",") W !,$P(A,D,%),$P(B,D,%),$P(C,D,%)
 K A,B,C,D,%
 Q
