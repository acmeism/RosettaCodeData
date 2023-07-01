% This implementation uses modern Prolog techniques
% in order to be an idiomatic solution that uses logical purity, generality and determinism wherever possible:
% - CLP(Z): constraint logic programming on integers.
% - library(reif): efficient logical predicates based on 'Indexing dif/2'.
:- module(fizz_buzz, [main/0, integer_fizzbuzz_below_100/2, integer_fizzbuzz/2]).

:- use_module(library(reif)).

% for Scryer-Prolog:
:- use_module(library(clpz)).
:- use_module(library(between)).
:- use_module(library(iso_ext)).
:- use_module(library(si)).

% for SWI-Prolog:
% :- use_module(library(clpfd)).

% Prints all solutions to `integer_fizzbuzz_below_100` each on a separate line, in order.
% Logically-impure shell, as currently there is no logically-pure way to write to a filestream.
main :-
    forall(integer_fizzbuzz_below_100(_, FizzBuzz), write_line(FizzBuzz)).

write_line(Value) :-
    write(Value),
    nl.

% Constrains FizzBuzz results to the range 1 <= X <= 100,
% and (for the 'most general query' where neither X or FizzBuzz is concrete)
% ensures results are traversed in order low -> high X.
%
% ?- integer_fizzbuzz_below_100(X, FizzBuzz) % generate all the results in order
% ?- integer_fizzbuzz_below_100(27, Result) % Find out what output `27` will produce (it's 'Fizz'.)
% ?- integer_fizzbuzz_below_100(X, 'Fizz')   % generate all the numbers which would print 'Fizz' in order (3, 6, 9, etc).
% ?- integer_fizzbuzz_below_100(X, Res), integer_si(Res) % generate all the numbers which would print themselves in order (1, 2, 4, 6, 7, 8, 11, etc).
% ?- integer_fizzbuzz_below_100(X, Res), is_of_type(integer, Res) % SWI-Prolog version doing the same.
integer_fizzbuzz_below_100(X, FizzBuzz) :-
    between(1, 100, X),
    integer_fizzbuzz(X, FizzBuzz).

% States the relationship between a number
% and its FizzBuzz representation.
%
% Because constraints are propagated lazily,
% prompting this predicate without having constrained `Num`
% to a particular integer value will give you its definition back.
% Put differently: This predicate returns the whole solution space at once,
% and external labeling techniques are required to traverse and concretize this solution space
% in an order that we like.
integer_fizzbuzz(Num, FizzBuzz) :-
    if_(Num mod 15 #= 0, FizzBuzz = 'FizzBuzz',
        if_(Num mod 5 #= 0, FizzBuzz = 'Buzz',
            if_(Num mod 3 #= 0, FizzBuzz = 'Fizz',
                Num = FizzBuzz)
           )
       ).

% Reifiable `#=`.
#=(X, Y, T) :-
    X #= X1,
    Y #= Y1,
    zcompare(C, X1, Y1),
    eq_t(C, T).

eq_t(=, true).
eq_t(<, false).
eq_t(>, false).
