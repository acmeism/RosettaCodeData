% ===
% Problem description
% ===
% http://rosettacode.org/wiki/Sort_disjoint_sublist
%
% Given a list of values and a set of integer indices into that value list,
% the task is to sort the values at the given indices, while preserving the
% values at indices outside the set of those to be sorted.
%
% Make your example work with the following list of values and set of indices:
%
%        Values: [7, 6, 5, 4, 3, 2, 1, 0]
%
%        Indices: {6, 1, 7}
%
% Where the correct result would be:
%
%        [7, 0, 5, 4, 3, 2, 1, 6].
%
% In case of one-based indexing, rather than the zero-based indexing above,
% you would use the indices {7, 2, 8} instead.
%
% The indices are described as a set rather than a list but any collection-type
% of those indices without duplication may be used as long as the example is
% insensitive to the order of indices given.


% ===
% Notes
% ===
% For predicate descriptions, see https://www.swi-prolog.org/pldoc/man?section=preddesc
%
% Solution using only predicates marked "builtin".
%
% - sort/2 is a built-in predicate. When called as sort(A,B) then
%          it sorts A to B according to the "standard order of terms",
%          (for integers, this means ascending order). It does remove
%          duplicates.
% - msort/2 is the same as sort/2 but does not remove duplicates.
%
% Everything is a list as there is no "set" datatype in Prolog.


% ===
% Main predicate (the one that would be exported from a Module)
% sort_disjoint_sublist(+Values,+Indexes,?ValuesSorted)
% ===

sort_disjoint_sublist(Values,Indexes,ValuesSorted) :-
   sort(Indexes,IndexesSorted),
   insert_fresh_vars(0,IndexesSorted,Values,FreshVars,ValsToSort,ValuesFreshened),
   msort(ValsToSort,ValsSorted),  % this is the "sorting of values"
   % The next two lines could be left out with suitable naming,
   % but they make explicit what happens:
   FreshVars = ValsSorted,         % fresh variables are unified with sorted variables
   ValuesSorted = ValuesFreshened. % ValuesFreshend is automatically the sought output

% ===
% Helper predicate (would not be exported from a Module)
% ===

% insert_fresh_vars(+CurIdx,+[I|Is],+[V|Vs],-FreshVars,-ValsToSort,-ValsFreshy)
%
%   CurIdx:     Monotonically increasing index into the list of values by
%               which we iterate.
%   [I|Is]:     Sorted list of indexes of interest. The smallest (leftmost)
%               element is removed on every "index hit", leaving eventually
%               an empty list, which gives us the base case.
%   [V|Vs]:     The list of values of interest with the leftmost element the
%               element with index CurIdx, all elements with lower index
%               having been discarded. Leftmost element is popped off on
%               each call.
%   FreshVars:  Constructed as output. If there was an "index hit", the
%               fresh variable pushed on FreshVars is also pushed on Vars.
%   ValsToSort: Constructed as output. If there was an "index hit", the
%               leftmost value from [V|Vs] is pushed on.
%   ValsFreshy: Constructed as output. If there was an "index hit", a fresh
%               variable is pushed on. If there was no "index hit", the actual
%               value from [V|Vs] is pushed on instead.

insert_fresh_vars(CurIdx,[I|Is],[V|Vs],FreshVars,ValsToSort,[V|ValsFreshy]) :-
   CurIdx<I, % no index hit, CurIdx is still too small, iterate over value
   !,
   succ(CurIdx,NextIdx),
   insert_fresh_vars(NextIdx,[I|Is],Vs,FreshVars,ValsToSort,ValsFreshy).

insert_fresh_vars(CurIdx,[I|Is],[V|Vs],[Fresh|FreshVars],[V|ValsToSort],[Fresh|ValsFreshy]) :-
   CurIdx=I, % index hit, replace value by fresh variable
   !,
   succ(CurIdx,NextIdx),
   insert_fresh_vars(NextIdx,Is,Vs,FreshVars,ValsToSort,ValsFreshy).

insert_fresh_vars(_,[],V,[],[],V).
