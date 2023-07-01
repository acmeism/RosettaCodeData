Eratosthenes := function(n)
    local a, i, j;
    a := ListWithIdenticalEntries(n, true);
    if n < 2 then
        return [];
    else
        for i in [2 .. n] do
            if a[i] then
                j := i*i;
                if j > n then
                    return Filtered([2 .. n], i -> a[i]);
                else
                    while j <= n do
                        a[j] := false;
                        j := j + i;
                    od;
                fi;
            fi;
        od;
    fi;
end;

Eratosthenes(100);

[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97 ]
