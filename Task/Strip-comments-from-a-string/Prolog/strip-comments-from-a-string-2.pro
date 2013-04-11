strip_1comment(A,D) :- ((S1=0'#;S1=0';),append(B,[S1|C],A)), \+ ((S2=0'#;S2=0';),append(_X,[S2|_Y],B)) -> B=D; A=D.
