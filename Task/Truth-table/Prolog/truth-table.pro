/*
    To evaluate the truth table a line of text is inputted and then there are three steps
    Let's say the expression is:
    'not a and (b or c)'

    Step 1: tokenize into atoms and brackets
    eg: Tokenized = [ not, a, and, '(', b, or, c, ')' ].

    Step 2: convert to a term that can be evaluated, and get out the variables
    eg: Expression = op(and, op(not, a), op(or, b, c)), Variables = [ a, b, c ]

    Step 3: permeate over the variables, substituting the values for each var, and evaluate the expression for each permutation
    eg: [ 0, 0, 0]
        op(and, op(not, 0), op(or, 0, 0))
        op(and, 1, op(or, 0, 0))
        op(and, 1, 0)
        0

        [ 0, 0, 1]
        op(and, op(not, 0), op(or, 0, 1))
        op(and, 1, op(or, 0, 0))
        op(and, 1, 1)
        1
*/
truth_table :-
    current_input(In),
    read_line_to_codes(In, Line),
    atom_codes(A, Line),
    atom_chars(A, Chars),

    % parse everything into the form we want
    phrase(tok(Tok), Chars, _),
    phrase(expr(Expr,Vars), Tok, _),
    list_to_set(Vars,VarSet),

    % evaluate
    print_expr(Expr, VarSet), !.

print_expr(Expr, Vars) :-
    % write the header (once)
    maplist(format('~p '), Vars),
    format('~n'),

    % write the results for as many times as there are rows
    eval_expr(Expr, Vars, Tvals, R),
    maplist(format('~p '), Tvals),
    format('~p~n', R),
    fail.
print_expr(_, _).


% Step 1 - tokenize the input into spaces, brackets and atoms
tok([A|As]) --> spaces(_), chars([X|Xs]), {atom_codes(A, [X|Xs])}, spaces(_), tok(As).
tok([A|As]) --> spaces(_), bracket(A), spaces(_), tok(As).
tok([]) --> [].
chars([X|Xs]) --> char(X), { dif(X, ')'), dif(X, '(') }, !, chars(Xs).
chars([]) --> [].
spaces([X|Xs]) --> space(X), !, spaces(Xs).
spaces([]) --> [].
bracket('(') --> ['('].
bracket(')') --> [')'].


% Step 2 - Parse the expression into an evaluable term
expr(op(I, E, E2), V) --> starter(E, V1), infix(I), expr(E2, V2), { append(V1, V2, V) }.
expr(E, V) --> starter(E, V).

starter(op(not, E),V) --> [not], expr(E, V).
starter(E,V) --> ['('], expr(E,V), [')'].
starter(V,[V]) --> variable(V).

infix(or) --> [or].
infix(and) --> [and].
infix(xor) --> [xor].
infix(nand) --> [nand].

variable(V) --> [V], \+ infix(V), \+ bracket(V).
space(' ') --> [' '].
char(X) --> [X], { dif(X, ' ') }.


% Step 3 - evaluate the parsed expression
eval_expr(Expr, Vars, Tvals, R) :-
    length(Vars,Len),
    length(Tvals, Len),
    maplist(truth_val, Tvals),
    eval(Expr, [Tvals,Vars],R).

eval(X, [Vals,Vars], R) :- nth1(N,Vars,X), nth1(N,Vals,R).
eval(op(Op,A,B), V, R) :- eval(A,V,Ae), eval(B,V,Be), e(Op,Ae,Be,R).
eval(op(not,A), V, R) :- eval(A,V,Ae), e(not,Ae,R).

truth_val(0). truth_val(1).

e(or,0,0,0). e(or,0,1,1). e(or,1,0,1). e(or,1,1,1).
e(and,0,0,0). e(and,0,1,0). e(and,1,0,0). e(and,1,1,1).
e(xor,0,0,0). e(xor,0,1,1). e(xor,1,0,1). e(xor,1,1,0).
e(nand,0,0,1). e(nand,0,1,1). e(nand,1,0,1). e(nand,1,1,0).
e(not, 1, 0). e(not, 0, 1).
