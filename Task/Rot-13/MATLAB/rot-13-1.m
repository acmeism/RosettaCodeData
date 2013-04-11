function r=rot13(s)
    if ischar(s)
        r=s;  % preallocation and copy of non-letters
        for i=1:size(s,1)
            for j=1:size(s,2)
                if isletter(s(i,j))
                    if s(i,j)>=97   % lower case
                        base = 97;
                    else            % upper case
                        base = 65;
                    end
                    r(i,j)=char(mod(s(i,j)-base+13,26)+base);
                end
            end
        end
    else
        error('Argument must be a CHAR')
    end
end
