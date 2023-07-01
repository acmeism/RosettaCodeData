function matrix = reverseSpiral(n)

    matrix = (-spiral(n))+n^2;

    if mod(n,2)==0
        matrix = flipud(matrix);
    else
        matrix = fliplr(matrix);
    end

end %reverseSpiral
