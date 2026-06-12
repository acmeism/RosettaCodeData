:- use_module(library(clpr)).

v3_add(v(X1,Y1,Z1),v(X2,Y2,Z2),v(X,Y,Z)) :-
	{ X = X1 + X2 },
	{ Y = Y1 + Y2 },
	{ Z = Z1 + Z2 }.
	
v3_mul(v(X1,Y1,Z1),M,v(X,Y,Z)) :-
	{ X = X1 * M },
	{ Y = Y1 * M },
	{ Z = Z1 * M }.
	
v3_muladd(V1,X1,V2,X2,R) :-
	v3_mul(V1,X1,V1X1),
	v3_mul(V2,X2,V2X2),
	v3_add(V1X1,V2X2,R).
	
v3_rotate(IV, JV, Alpha, R1, R2) :-
	{ SinA = sin(Alpha) },
	{ CosA = cos(Alpha) },
	{ NegSinA = 0 - SinA },
	v3_muladd(IV, CosA, JV, SinA, R1),
	v3_muladd(IV, NegSinA, JV, CosA, R2).
	
v3_abs(v(X,Y,Z), Abs) :- { Abs = (X * X + Y * Y + Z * Z) ^ 0.5 }.
	
orbital_state_vectors(
	o(SemiMajor,Ecc,Inc,LongAscNode,ArgPer,TrueAnon),
	Position,
	Speed) :-
	
	v3_rotate(v(1,0,0),v(0,1,0),LongAscNode,I1,J1),	
	v3_rotate(J1,v(0,0,1),Inc,J2,_),
	v3_rotate(I1,J2,ArgPer,I,J),
	
	find_l(Ecc, SemiMajor, L),
	
	{ C = cos(TrueAnon) },
	{ S = sin(TrueAnon) },
	{ R = L / (1.0 + Ecc * C ) },
	{ RPrime = S * R * R / L },
	
	v3_muladd(I, C, J, S, P1),
	v3_mul(P1, R, Position),
	
	{ SpeedIr = RPrime * C - R * S },
	{ SpeedJr = RPrime * S + R * C },
	v3_muladd(I, SpeedIr, J, SpeedJr, SpeedA),
	v3_abs(SpeedA, SpeedAbs),
	v3_mul(SpeedDiv, SpeedAbs, SpeedA),
	{ Sf = (2.0 / R - 1.0 / SemiMajor ) ^ 0.5 },
	v3_mul(SpeedDiv, Sf, Speed).
	
	
find_l(1.0, SemiMajor, L) :-
	{ L = SemiMajor * 2.0 }.
find_l(Ecc, SemiMajor, L) :-
	dif(Ecc,1.0),
	{ L = SemiMajor * (1.0 - Ecc * Ecc) }.
