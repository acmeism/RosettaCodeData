:- initialization(main).

main :-
	sum(b=2,output=Output,a=1),
	writeln(Output).

sum(A1,B1,C1) :-
	named_args([A1,B1,C1],[a=A,b=B,output=Output]),
	Output is A + B.

named_args([],_).
named_args([A|B],C) :-
	member(A,C),
	named_args(B,C).
