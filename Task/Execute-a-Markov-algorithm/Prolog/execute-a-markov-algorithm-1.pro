:- module('markov.pl', [markov/3, apply_markov/3]).

:- use_module(library(lambda)).

apply_markov(Rules, Sentence, Replacement) :-
    maplist(\X^Y^(atom_chars(X, Ch), phrase(markov(Y), Ch, [])), Rules, TmpRules),
    % comments produce empty rules
    exclude(=([]), TmpRules, LstRules),

    atom_chars(Sentence, L),
    apply_rules(L, LstRules, R),
    atom_chars(Replacement, R).

apply_rules(In, Rules, Out ) :-
    apply_one_rule(In, Rules, Out1, Keep_On),
    (   Keep_On = false
    ->  Out = Out1
    ;   apply_rules(Out1, Rules, Out)).


apply_one_rule(In, [Rule | Rules], Out, Keep_On) :-
    extract(Rule, In, Out1, KeepOn),
    (   KeepOn = false
    ->  Out = Out1, Keep_On = KeepOn
    ;   (KeepOn = stop
        ->  Out = Out1,
        Keep_On = true
        ;   apply_one_rule(Out1, Rules, Out, Keep_On))).

apply_one_rule(In, [], In, false) .


extract([Pattern, Replace], In, Out, Keep_On) :-
    (   Replace = [.|Rest]
    ->  R = Rest
    ;   R = Replace),
    (   (append(Pattern, End, T), append(Deb, T, In))
    ->  extract([Pattern, Replace], End, NewEnd, _Keep_On),
        append_3(Deb, R, NewEnd, Out),
        Keep_On = stop
    ;   Out = In,
        (   R = Replace
        ->  Keep_On = true
        ;   Keep_On = false)).


append_3(A, B, C, D) :-
           append(A, B, T),
           append(T, C, D).

% creation of the rules
markov(A) --> line(A).

line(A) --> text(A), newline.


newline --> ['\n'], newline.
newline --> [].

text([]) --> comment([]).
text(A) --> rule(A).

comment([]) --> ['#'], anything.

anything --> [X], {X \= '\n'}, anything.
anything --> ['\n'].
anything --> [].

rule([A,B]) -->
    pattern(A), whitespaces, ['-', '>'], whitespaces, end_rule(B).

pattern([X | R]) --> [X], {X \= '\n'}, pattern(R).
pattern([]) --> [].

whitespaces --> ['\t'], whitespace.
whitespaces --> [' '], whitespace.

whitespace --> whitespaces.
whitespace --> [].

end_rule([.| A]) --> [.], rest_of_rule(A).
end_rule(A) --> rest_of_rule(A).
end_rule([]) --> [].

rest_of_rule(A) --> replacement(A).

replacement([X | R]) --> [X], {X \= '\n'}, replacement(R).
replacement([]) --> [].
