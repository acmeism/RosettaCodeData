function s = nth(n)
    tens = mod(n, 100);
    if tens > 9 && tens < 20
        suf = 'th';
    else
        switch mod(n, 10)
            case 1
                suf = 'st';
            case 2
                suf = 'nd';
            case 3
                suf = 'rd';
            otherwise
                suf = 'th';
        end
    end
    s = sprintf('%d%s', n, suf);
end
