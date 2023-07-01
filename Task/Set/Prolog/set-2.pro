%%  Set creation

?- list_to_ord_set([1,2,3,4], A), list_to_ord_set([2,4,6,8], B).
A = [1, 2, 3, 4],
B = [2, 4, 6, 8].

%% Test m ∈ S -- "m is an element in set S"

?- ord_memberchk(2, $A).
true.

%% A ∪ B -- union; a set of all elements either in set A or in set B.

?- ord_union($A, $B, Union).
Union = [1, 2, 3, 4, 6, 8].

%% A ∩ B -- intersection; a set of all elements in both set A and set B.

?- ord_intersection($A, $B, Intersection).
Intersection = [2, 4].

%% A ∖ B -- difference; a set of all elements in set A, except those in set B.

?- ord_subtract($A, $B, Diff).
Diff = [1, 3].

%% A ⊆ B -- subset; true if every element in set A is also in set B.

?- ord_subset($A, $B).
false.

?- ord_subset([2,4], $B).
true.

%% A = B -- equality; true if every element of set A is in set B and vice-versa.

?- $A == $B.
false.

?- $A == [1,2,3,4].
true.

%% Definition of a proper subset:

ord_propsubset(A, B) :-
    ord_subset(A, B),
    \+(A == B).

%% add/remove elements

?- ord_add_element($A, 19, NewA).
NewA = [1, 2, 3, 4, 19].

?- ord_del_element($NewA, 3, NewerA).
NewerA = [1, 2, 4, 19].
