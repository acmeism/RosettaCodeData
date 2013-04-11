Clear[Ackermann3]
$RecursionLimit=Infinity;
Ackermann3[0,n_]:=n+1;
Ackermann3[1,n_]:=n+2;
Ackermann3[2,n_]:=3+2n;
Ackermann3[3,n_]:=5+8 (2^n-1);
Ackermann3[m_,0]:=Ackermann3[m-1,1];
Ackermann3[m_,n_]:=Ackermann3[m-1,Ackermann3[m,n-1]]
