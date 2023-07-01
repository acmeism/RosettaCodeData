%rotates one list clockwise by one integer
rotate(Int,List,Rotated) :-
	integer(Int),
	length(Suff,Int),
	append(Pre,Suff,List),
	append(Suff,Pre,Rotated).
%rotates a list of lists by a list of integers
rotate(LoInts,LoLists,Rotated) :-
	is_list(LoInts),
	maplist(rotate,LoInts,LoLists,Rotated).

%helper function
append_(Suff,Pre,List) :-
	append([Pre],Suff,List).	
idmatrix(N,IdMatrix):-
	%make an N length list of 1s and append with N-1 0s
	length(Ones,N),
	maplist(=(1),Ones),
	succ(N0,N),
	length(Zeros,N0),
	maplist(=(0),Zeros),
	maplist(append_(Zeros),Ones,M),
	%create the offsets at rotate each row
	numlist(0,N0,Offsets),
	rotate(Offsets,M,IdMatrix).

main :-
	idmatrix(5,I),
	maplist(writeln,I).
