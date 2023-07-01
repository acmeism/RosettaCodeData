singleassignment:-
    functor(Array,array,100), % create a term with 100 free Variables as arguments
                              % index of arguments start at 1
    arg(1 ,Array,a),          % put an a at position 1
    arg(12,Array,b),          % put an b at position 12
    arg(1 ,Array,Value1),     % get the value at position 1
    print(Value1),nl,         % will print Value1 and therefore a followed by a newline
    arg(4 ,Array,Value2),     % get the value at position 4 which is a free Variable
    print(Value2),nl.         % will print that it is a free Variable followed by a newline
