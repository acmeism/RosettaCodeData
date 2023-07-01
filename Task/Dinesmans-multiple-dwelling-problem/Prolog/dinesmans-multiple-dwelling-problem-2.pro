select([A|As],S):- select(A,S,S1),select(As,S1).
select([],_).

dinesmans(X) :-
    %% Baker, Cooper, Fletcher, Miller, and Smith live on different floors
    %% of an apartment house that contains only five floors.
    select([Baker,Cooper,Fletcher,Miller,Smith],[1,2,3,4,5]),

    %% Baker does not live on the top floor.
    Baker =\= 5,

    %% Cooper does not live on the bottom floor.
    Cooper =\= 1,

    %% Fletcher does not live on either the top or the bottom floor.
    Fletcher =\= 1, Fletcher =\= 5,

    %% Miller lives on a higher floor than does Cooper.
    Miller > Cooper,

    %% Smith does not live on a floor adjacent to Fletcher's.
    1 =\= abs(Smith - Fletcher),

    %% Fletcher does not live on a floor adjacent to Cooper's.
    1 =\= abs(Fletcher - Cooper),

    %% Where does everyone live?
    X = ['Baker'(Baker), 'Cooper'(Cooper), 'Fletcher'(Fletcher),
         'Miller'(Miller), 'Smith'(Smith)].

main :-  bagof( X, dinesmans(X), L )
         -> maplist( writeln, L), nl, write('No more solutions.')
         ;  write('No solutions.').
