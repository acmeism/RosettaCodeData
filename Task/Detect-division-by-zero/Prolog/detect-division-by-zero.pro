div(A, B, C, Ex) :-
    catch((C is A/B), Ex, (C = infinity)).
