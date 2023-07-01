exp_recursive(Base, NegExp, NegPower) :-
    NegExp < 0,
    Exp is NegExp * -1,
    exp_recursive_(Base, Exp, Base, Power),
    NegPower is 1 / Power.
exp_recursive(Base, Exp, Power) :-
    Exp > 0,
    exp_recursive_(Base, Exp, Base, Power).
exp_recursive(_, 0, 1).

exp_recursive_(_,    1,   Power, Power).
exp_recursive_(Base, Exp, Acc,   Power)   :-
    Exp > 1,
    NewAcc is Base * Acc,
    NewExp is Exp  - 1,
    exp_recursive_(Base, NewExp, NewAcc, Power).
