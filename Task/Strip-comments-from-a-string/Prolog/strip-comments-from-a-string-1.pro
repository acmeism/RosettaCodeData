stripcomment(A,B) :- stripcomment(A,B,a).
stripcomment([A|AL],[A|BL],a) :- \+ A=0';, \+ A=0'# , \+ A=10, \+ A=13 , stripcomment(AL,BL,a).
stripcomment([A|AL],   BL ,a) :-  ( A=0';;    A=0'#), \+ A=10, \+ A=13 , stripcomment(AL,BL,b).
stripcomment([A|AL],   BL ,b) :-                      \+ A=10, \+ A=13 , stripcomment(AL,BL,b).
stripcomment([A|AL],[A|BL],_M):-                       ( A=10;    A=13), stripcomment(AL,BL,a).
stripcomment([],[],_M).
start :-
In = "apples, pears ; and bananas
apples, pears # and bananas",
    stripcomment(In,Out),
    format("~s~n",[Out]).
