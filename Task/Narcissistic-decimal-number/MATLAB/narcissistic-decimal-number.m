function testNarcissism
    x = 0;
    c = 0;
    while c < 25
        if isNarcissistic(x)
            fprintf('%d ', x)
            c = c+1;
        end
        x = x+1;
    end
    fprintf('\n')
end

function tf = isNarcissistic(n)
    dig = sprintf('%d', n) - '0';
    tf = n == sum(dig.^length(dig));
end
