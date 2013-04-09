destructive:-
    functor(Array,array,100), % create a term with 100 free Variables as arguments
                              % index of arguments start at 1
    setarg(1 ,Array,a),       % put an a at position 1
    setarg(12,Array,b),       % put an b at position 12
    setarg(1, Array,c),       % overwrite value at position 1 with c
    arg(1 ,Array,Value1),     % get the value at position 1
    print(Value1),nl.         % will print Value1 and therefore c followed by a newline
