listvariant:-
    length(List,100),          % create a list of length 100
    nth1(1 ,List,a),           % put an a at position 1 , nth1/3 uses indexing from 1, nth0/3 from 0
    nth1(12,List,b),           % put an b at position 3
    append(List,[d],List2),    % append an d at the end , List2 has 101 elements
    length(Add,10),            % create a new list of length 10
    append(List2,Add,List3),   % append 10 free variables to List2 , List3 now has 111 elements
    nth1(1 ,List3,Value),      % get the value at position 1
    print(Value),nl.           % will print out a
