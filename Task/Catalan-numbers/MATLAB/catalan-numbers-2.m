function n = catalanNumbers(n)
    n = [1 cumprod((2:4:4*n-6) ./ (2:n))];
end
