:- object(tree_traversal).

    :- public(orders/1).
    orders(Tree) :-
        write('Pre-order:   '), pre_order(Tree), nl,
        write('In-order:    '), in_order(Tree), nl,
        write('Post-order:  '), post_order(Tree), nl,
        write('Level-order: '), level_order(Tree).

    :- public(orders/0).
    orders :-
        tree(Tree),
        orders(Tree).

    tree(
        t(1,
            t(2,
                t(4,
                    t(7, t, t),
                    t
                ),
                t(5, t, t)
            ),
            t(3,
                t(6,
                    t(8, t, t),
                    t(9, t, t)
                ),
                t
            )
        )
    ).

    pre_order(t).
    pre_order(t(Value, Left, Right)) :-
        write(Value), write(' '),
        pre_order(Left),
        pre_order(Right).

    in_order(t).
    in_order(t(Value, Left, Right)) :-
        in_order(Left),
        write(Value), write(' '),
        in_order(Right).

    post_order(t).
    post_order(t(Value, Left, Right)) :-
        post_order(Left),
        post_order(Right),
        write(Value), write(' ').

    level_order(t).
    level_order(t(Value, Left, Right)) :-
        % write tree root value
        write(Value), write(' '),
        % write rest of the tree
        level_order([Left, Right], Tail-Tail).

    level_order([], Trees-[]) :-
        (   Trees \= [] ->
            % print next level
            level_order(Trees, Tail-Tail)
        ;   % no more levels
            true
        ).
    level_order([Tree| Trees], Rest0) :-
        (   Tree = t(Value, Left, Right) ->
            write(Value), write(' '),
            % collect the subtrees to print the next level
            append(Rest0, [Left, Right| Tail]-Tail, Rest1),
            % continue printing the current level
            level_order(Trees, Rest1)
        ;   % continue printing the current level
            level_order(Trees, Rest0)
        ).

    % use difference-lists for constant time append
    append(List1-Tail1, Tail1-Tail2, List1-Tail2).

:- end_object.
