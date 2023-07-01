function answer = ethiopianMultiplication(multiplicand,multiplier)

    %Generate columns
    while multiplicand(end)>1
        multiplicand(end+1,1) = halveInt( multiplicand(end) );
        multiplier(end+1,1) = doubleInt( multiplier(end) );
    end

    %Strike out appropriate rows
    multiplier( isEven(multiplicand) ) = [];

    %Generate answer
    answer = sum(multiplier);

end
