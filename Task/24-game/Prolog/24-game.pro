:- initialization(main).


answer(24).
play :- round, play ; true.

round :-
    prompt(Ns), get_line(Input), Input \= "stop"
  , ( phrase(parse(Ns,[]), Input) -> Result = 'correct'
                                   ; Result = 'wrong'
    ), write(Result), nl, nl
  . % where
    prompt(Ns)  :- length(Ns,4), maplist(random(1,10), Ns)
                 , write('Digits: '), write(Ns), nl
                 .

parse([],[X])     --> { answer(X) }.
parse(Ns,[Y,X|S]) --> "+", { Z is X  +  Y }, parse(Ns,[Z|S]).
parse(Ns,[Y,X|S]) --> "-", { Z is X  -  Y }, parse(Ns,[Z|S]).
parse(Ns,[Y,X|S]) --> "*", { Z is X  *  Y }, parse(Ns,[Z|S]).
parse(Ns,[Y,X|S]) --> "/", { Z is X div Y }, parse(Ns,[Z|S]).
parse(Ns,Stack)   --> " ", parse(Ns,Stack).
parse(Ns,Stack)   --> { select(N,Ns,Ns1), number_codes(N,[Code]) }
                    , [Code], parse(Ns1,[N|Stack])
                    .

get_line(Xs) :- get_code(X)
              , ( X == 10 -> Xs = [] ; Xs = [X|Ys], get_line(Ys) )
              .
main :- randomize, play, halt.
