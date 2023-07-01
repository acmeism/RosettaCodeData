function perf = isPerfect(n)
    if n < 2
        perf = false;
    else
        total = 1;
        k = 2;
        quot = n;
        while k < quot && total <= n
            if ~mod(n, k)
                total = total+k;
                quot = n/k;
                if quot ~= k
                    total = total+quot;
                end
            end
            k = k+1;
        end
        perf = total == n;
    end
end
