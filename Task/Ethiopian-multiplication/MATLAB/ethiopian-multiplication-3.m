%Returns a logical 1 if the number is even, 0 otherwise.
function trueFalse = isEven(number)

    trueFalse = logical( mod(number,2)==0 );

end
