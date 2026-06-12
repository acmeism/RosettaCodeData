clear all;close all;clc;
disp(num2str(funcE(5, 13)))

function result = funcE(k, n)
    s = cell(1, n);
    for i = 1:n
        s{i} = (i <= k);
    end

    d = n - k;
    [n, k] = deal(max(k, d), min(k, d));
    z = d;

    while z > 0 || k > 1
        for i = 1:k
            s{i} = [s{i}, s{end - i + 1}];
        end
        s = s(1:end-k);
        z = z - k;
        d = n - k;
        [n, k] = deal(max(k, d), min(k, d));
    end

    result = [s{:}];
end
