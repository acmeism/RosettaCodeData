%% ^^/3
%
%   True if Power is Base ^ Exp.

^^(Base, Exp, Power) :-
    ( Exp < 0   ->  Power is 1 / (Base ^^ (Exp * -1))            % If exponent is negative, then ...

    ; Exp > 0   ->  length(Powers, Exp),                         % If exponent is positive, then
                    foldl( exp_folder(Base), Powers, 1, Power )  %    Powers is a list of free variables with length Exp
                                                                 %    and Power is Powers folded with exp_folder/4

    ; Power = 1                                                  % otherwise Exp must be 0, so
    ).

%% exp_folder/4
%
%       True when Power is the product of Base and Powers.
%
%       This predicate is designed to work with foldl and a list of free variables.
%       It passes the result of each evaluation to the next application through its
%       fourth argument, instantiating the elements of Powers to each successive Power of the Base.

exp_folder(Base, Power, Powers, Power) :-
    Power is Base * Powers.
