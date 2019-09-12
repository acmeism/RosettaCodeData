% create a list
L = [a,b,c,d],

% prepend to the list
L2 = [before_a|L],

% append to the list
append(L2, ['Hello'], L3),

% delete from list
exclude(=(b), L3, L4).
