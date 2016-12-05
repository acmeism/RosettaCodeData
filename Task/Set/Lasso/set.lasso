// Extend set type
define set->issubsetof(p::set) => .intersection(#p)->size == .size
define set->oncompare(p::set) => .intersection(#p)->size - .size

//	Set creation
local(set1) = set('j','k','l','m','n')
local(set2) = set('m','n','o','p','q')

//Test m ∈ S -- "m is an element in set S"
#set1 >> 'm'

// A ∪ B -- union; a set of all elements either in set A or in set B.
#set1->union(#set2)

//A ∩ B -- intersection; a set of all elements in both set A and set B.
#set1->intersection(#set2)

//A ∖ B -- difference; a set of all elements in set A, except those in set B.
#set1->difference(#set2)

//A ⊆ B -- subset; true if every element in set A is also in set B.
#set1->issubsetof(#set2)

//A = B -- equality; true if every element of set A is in set B and vice-versa.
#set1 == #set2
