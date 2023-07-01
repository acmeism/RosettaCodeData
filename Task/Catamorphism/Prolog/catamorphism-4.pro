% Computes "Out" as:
%
% Out --<--f--<--f--<--f--<--f--<-- starter value
%          |     |     |     |
%          a     b     c     d

foldr(Foldy,[Item|Items],Starter,AccUp) :-    % case of nonempty list
   !,                                         % GREEN CUT for determinism
   foldr(Foldy,Items,Starter,AccUpPrev),      % recurse (NOT open to tail-call optimization)
   call(Foldy,Item,AccUpPrev,AccUp).          % call Foldy(Item,AccupPrev,AccUp) as last action

foldr(_,[],Starter,AccUp) :-                  % empty list: bounce Starter "upwards" into AccUp
   AccUp=Starter.                             % unification not in head for clarity
