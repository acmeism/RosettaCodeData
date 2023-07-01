% A quaternion is represented as a complex term qx/4
add(qx(R0,I0,J0,K0), qx(R1,I1,J1,K1), qx(R,I,J,K)) :-
	!, R is R0+R1, I is I0+I1, J is J0+J1, K is K0+K1.
add(qx(R0,I,J,K), F, qx(R,I,J,K)) :-
	number(F), !, R is R0 + F.
add(F, qx(R0,I,J,K), Qx) :-
	add(qx(R0,I,J,K), F, Qx).
mul(qx(R0,I0,J0,K0), qx(R1,I1,J1,K1), qx(R,I,J,K)) :- !,
	R is R0*R1 - I0*I1 - J0*J1 - K0*K1,
	I is R0*I1 + I0*R1 + J0*K1 - K0*J1,
	J is R0*J1 - I0*K1 + J0*R1 + K0*I1,
	K is R0*K1 + I0*J1 - J0*I1 + K0*R1.
mul(qx(R0,I0,J0,K0), F, qx(R,I,J,K)) :-
	number(F), !, R is R0*F, I is I0*F, J is J0*F, K is K0*F.
mul(F, qx(R0,I0,J0,K0), Qx) :-
	mul(qx(R0,I0,J0,K0),F,Qx).
abs(qx(R,I,J,K), Norm) :-
	Norm is sqrt(R*R+I*I+J*J+K*K).
negate(qx(Ri,Ii,Ji,Ki),qx(R,I,J,K)) :-
	R is -Ri, I is -Ii, J is -Ji, K is -Ki.
conjugate(qx(R,Ii,Ji,Ki),qx(R,I,J,K)) :-
	I is -Ii, J is -Ji, K is -Ki.
