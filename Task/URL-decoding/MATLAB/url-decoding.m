function u = urldecoding(s)
    u = '';
    k = 1;
    while k<=length(s)
        if s(k) == '%' && k+3 <= length(s)
            u = sprintf('%s%c', u, char(hex2dec(s((k+1):(k+2)))));
            k = k + 3;
        else
            u = sprintf('%s%c', u, s(k));
            k = k + 1;
        end
    end
end
