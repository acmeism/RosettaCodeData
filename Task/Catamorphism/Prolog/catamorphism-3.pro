% Computes "Out" as:
%
% starter value -->--f-->--f-->--f-->--f-->-- Out
%                    |     |     |     |
%                    a     b     c     d


foldl(Foldy,[Item|Items],Acc,Result) :-    % case of nonempty list
   !,                                      % GREEN CUT for determinism
   call(Foldy,Item,Acc,AccNext),           % call Foldy(Item,Acc,AccNext)
   foldl(Foldy,Items,AccNext,Result).      % then recurse (open to tail call optimization)

foldl(_,[],Acc,Result) :-                  % case of empty list
   Acc=Result.                             % unification not in head for clarity
