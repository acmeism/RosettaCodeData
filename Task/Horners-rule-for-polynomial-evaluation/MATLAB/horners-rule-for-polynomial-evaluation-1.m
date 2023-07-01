function accumulator = hornersRule(x,coefficients)

    accumulator = 0;

    for i = (numel(coefficients):-1:1)
        accumulator = (accumulator * x) + coefficients(i);
    end

end
