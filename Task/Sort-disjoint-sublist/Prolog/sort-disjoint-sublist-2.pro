% ===
% Main predicate
% ===

sort_disjoint_sublist(Values,Indexes,ValuesSorted) :-
   sort(Indexes,IndexesSorted),
   insert_fresh_vars_by_splintering(IndexesSorted,Values,FreshVars,ValsToSort,ValuesFreshened),
   msort(ValsToSort,ValsSorted),  % this is the "sorting of values"
   % The next two lines could be left out with suitable naming,
   % but they make explicit what happens:
   FreshVars = ValsSorted,         % fresh variables are unified with sorted variables
   ValuesSorted = ValuesFreshened. % ValuesFreshend is automatically the sought output

% ===
% Helpers
% ===

insert_fresh_vars_by_splintering([I|Is],Values,[Fresh|FreshVars],[ValAtI|ValsToSort],ValsFreshyFinal) :-
   splinter(Values,I,ValAtI,ValsFront,ValsBack),         % splinter  Values  --> ValsFront + ValAtI + ValsBack
   append([ValsFront,[Fresh],ValsBack],ValsFreshyNext),  % recompose ValsFront + Fresh + ValsBack --> ValuesFreshyNext
   insert_fresh_vars_by_splintering(Is,ValsFreshyNext,FreshVars,ValsToSort,ValsFreshyFinal).

insert_fresh_vars_by_splintering([],V,[],[],V).

% "splinter" a list into a frontlist, the element at position N and a backlist

splinter(List, N, Elem, Front, Back) :-
    length(Front, N),
    append(Front, [Elem|Back], List).
