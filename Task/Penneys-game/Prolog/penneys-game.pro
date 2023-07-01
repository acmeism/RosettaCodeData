play :- rand1(R), game(R).

game(h) :-
    format('Your turn first!~n'), player_move(P),
    response(P,C), format('I am choosing '), maplist(writec, C), nl,
    rand3(R), maplist(writec,R),
    roll(P, C, R).

game(t) :-
    rand3(C),
    format('I am choosing '), maplist(writec, C), nl,
    player_move(P),
    rand3(R), maplist(writec, R),
    roll(P, C, R).

player_move([P1,P2,P3]) :-
    read_line_to_codes(user_input,Codes),
    maplist(char_code,[P1,P2,P3],Codes).

roll(P, _, P) :- format('~nYou Win!~n'), !.
roll(_, C, C) :- format('~nI Win!~n'), !.

roll(P, C, [_,A,B]) :-
    rand1(R),
    coin_s(R,S),
    write(S),
    roll(P,C,[A,B,R]).

response([A,B,_], [C,A,B]) :- opp(A,C).

writec(A) :- coin_s(A,A1), write(A1).
rand1(R) :- random(V), round(V,I), coin(I,R).
rand3([R1,R2,R3]) :- rand1(R1), rand1(R2), rand1(R3).

coin(0,h). coin(1,t).
coin_s(h, 'H'). coin_s(t, 'T').
opp(h, t). opp(t, h).
