function findHappyNumbers
    nHappy = 0;
    k = 1;
    while nHappy < 8
        if isHappyNumber(k, [])
            fprintf('%d ', k)
            nHappy = nHappy+1;
        end
        k = k+1;
    end
    fprintf('\n')
end

function hap = isHappyNumber(k, prev)
    if k == 1
        hap = true;
    elseif ismember(k, prev)
        hap = false;
    else
        hap = isHappyNumber(sum((sprintf('%d', k)-'0').^2), [prev k]);
    end
end
