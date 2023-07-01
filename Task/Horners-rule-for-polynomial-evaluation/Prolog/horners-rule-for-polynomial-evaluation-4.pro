:- module(_, [horner/3], [fsyntax, hiord]).
:- use_module(library(hiordlib)).
horner(L, X) := ~foldr((''(H,V0,V) :- V is V0*X + H), L, 0).
