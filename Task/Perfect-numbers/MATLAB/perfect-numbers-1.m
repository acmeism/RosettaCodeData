function perf = isPerfect(n)
    total = 0;
    for k = 1:n-1
        if ~mod(n, k)
            total = total+k;
        end
    end
    perf = total == n;
end
