spam([
    "hi there, how are you today?",
    "I'd like to present to you the washing machine 9001.",
    "You have been nominated to win one of these!",
    "Just make sure you don't break it"
]).

sentence_type(S, 'Q') :- sub_atom(S, _, 1, 0, '?'), !.
sentence_type(S, 'E') :- sub_atom(S, _, 1, 0, '!'), !.
sentence_type(S, 'S') :- sub_atom(S, _, 1, 0, '.'), !.
sentence_type(_, 'N').

print_sentences([]).
print_sentences([H|T]) :-
    sentence_type(H, Type),
    format('~w -> ~w~n', [H, Type]),
    print_sentences(T).

main :-
    spam(Sentences),
    print_sentences(Sentences).
