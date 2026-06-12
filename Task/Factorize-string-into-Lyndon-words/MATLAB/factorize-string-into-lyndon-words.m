clear all;close all;clc;
m = '0';
for i = 1:7
    m0 = m;
    m = strrep(m, '0', 'a');
    m = strrep(m, '1', '0');
    m = strrep(m, 'a', '1');
    m = strcat(m0, m);
end

factorization = chenFoxLyndonFactorization(m);
for index=1:length(factorization)
    disp(factorization(index));
end


function factorization = chenFoxLyndonFactorization(s)
    n = length(s);
    i = 1;
    factorization = {};
    while i <= n
        j = i + 1;
        k = i;
        while j <= n && s(k) <= s(j)
            if s(k) < s(j)
                k = i;
            else
                k = k + 1;
            end
            j = j + 1;
        end
        while i <= k
            factorization{end+1} = s(i:i + j - k - 1);
            i = i + j - k;
        end
    end
    assert(strcmp(join(factorization, ''), s));
end
