function coefficients = binomialCoeff(n,k)

    coefficients = zeros(numel(n),numel(k)); %Preallocate memory

    columns = (1:numel(k)); %Preallocate row and column counters
    rows = (1:numel(n));

    %Iterate over every row and column. The rows represent the n number,
    %and the columns represent the k number. If n is ever greater than k,
    %the nchoosek function will throw an error. So, we test to make sure
    %it isn't, if it is then we leave that entry in the coefficients matrix
    %zero. Which makes sense combinatorically.
    for row = rows
        for col = columns
            if k(col) <= n(row)
                coefficients(row,col) = nchoosek(n(row),k(col));
            end
        end
    end

end %binomialCoeff
