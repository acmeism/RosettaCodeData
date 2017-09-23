function n = catalanNumbers(n)
    n = arrayfun(@(n)prod(n+1:2*n)/prod(1:n+1), n);
end
