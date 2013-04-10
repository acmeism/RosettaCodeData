dinesmans(X) :-
    %% 1. Baker, Cooper, Fletcher, Miller, and Smith live on different floors
    %%    of an apartment house that contains only five floors.
    Domain = [1,2,3,4,5],

    %% 2. Baker does not live on the top floor.
    select(Baker,Domain,D1), Baker =\= 5,

    %% 3. Cooper does not live on the bottom floor.
    select(Cooper,D1,D2), Cooper =\= 1,

    %% 4. Fletcher does not live on either the top or the bottom floor.
    select(Fletcher,D2,D3), Fletcher =\= 1, Fletcher =\= 5,

    %% 5. Miller lives on a higher floor than does Cooper.
    select(Miller,D3,D4), Miller > Cooper,

    %% 6. Smith does not live on a floor adjacent to Fletcher's.
    select(Smith,D4,_), 1 =\= abs(Smith - Fletcher),

    %% 7. Fletcher does not live on a floor adjacent to Cooper's.
    1 =\= abs(Fletcher - Cooper),

    %% Where does everyone live?
    X = ['Baker'(Baker), 'Cooper'(Cooper), 'Fletcher'(Fletcher),
         'Miller'(Miller), 'Smith'(Smith)].
