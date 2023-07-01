for(Lo,Hi,Step,Lo)  :- Step>0, Lo=<Hi.
for(Lo,Hi,Step,Val) :- Step>0, plus(Lo,Step,V), V=<Hi, !, for(V,Hi,Step,Val).
for(Hi,Lo,Step,Hi)  :- Step<0, Lo=<Hi.
for(Hi,Lo,Step,Val) :- Step<0, plus(Hi,Step,V), Lo=<V, !, for(V,Lo,Step,Val).

sym(x,5).                 % symbolic lookups for values
sym(y,-5).
sym(z,-2).
sym(one,1).
sym(three,3).
sym(seven,7).

range(-three,3^3,three).  % as close as we can syntactically get
range(-seven,seven,x).
range(555,550-y,1).
range(22,-28, -three).
range(1927,1939,1).
range(x,y,z).
range(11^x,11^x+one,1).

translate(V, V)   :- number(V), !.    % difference list based parser
translate(S, V)   :- sym(S,V), !.
translate(-S, V)  :- translate(S,V0), !, V is -V0.
translate(A+B, V) :- translate(A,A0), translate(B, B0), !, V is A0+B0.
translate(A-B, V) :- translate(A,A0), translate(B, B0), !, V is A0-B0.
translate(A^B, V) :- translate(A,A0), translate(B, B0), !, V is A0^B0.

range_value(Val) :-             % enumerate values for all ranges in order
	range(From,To,Step),
	translate(From,F), translate(To,T), translate(Step,S),
	for(F,T,S,Val).

calc_values([], S, P, S, P).    % calculate all values in generated order
calc_values([J|Js], S, P, Sum, Product) :-
  S0 is S + abs(J), ((abs(P)< 2^27, J \= 0) -> P0 is P * J; P0=P),
  !, calc_values(Js, S0, P0, Sum, Product).

calc_values(Sum, Product) :-    % Find the sum and product
	findall(V, range_value(V), Values),
	calc_values(Values, 0, 1, Sum, Product).
