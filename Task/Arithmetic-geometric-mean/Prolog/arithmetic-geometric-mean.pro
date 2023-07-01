agm(A,G,A) :- abs(A-G) < 1.0e-15, !.
agm(A,G,Res) :- A1 is (A+G)/2.0, G1 is sqrt(A*G),!, agm(A1,G1,Res).

?- agm(1,1/sqrt(2),Res).
Res = 0.8472130847939792.
