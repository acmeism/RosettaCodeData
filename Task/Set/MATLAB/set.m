    % Set creation
	s = [1, 2, 4];     % numeric values
	t = {'a','bb','ccc'}; % cell array of strings
        u = unique([1,2,3,3,2,3,2,4,1]);   % set consists only of unique elements
    % Test m ∈ S -- "m is an element in set S"
        ismember(m, S)
    % A ∪ B -- union; a set of all elements either in set A or in set B.
	union(A, B)
    % A ∩ B -- intersection; a set of all elements in both set A and set B.
	intersect(A, B)
    % A ∖ B -- difference; a set of all elements in set A, except those in set B.
	setdiff(A, B)
    % A ⊆ B -- subset; true if every element in set A is also in set B.
        all(ismember(A, B))
    % A = B -- equality; true if every element of set A is in set B and vice-versa.
        isempty(setxor(A, B))
