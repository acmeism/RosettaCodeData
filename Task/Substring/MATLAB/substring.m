    % starting from n characters in and of m length;
        s(n+(1:m))
        s(n+1:n+m)
    % starting from n characters in, up to the end of the string;
        s(n+1:end)
    % whole string minus last character;
        s(1:end-1)
    % starting from a known character within the string and of m length;
        s(find(s==c,1)+[0:m-1])
    % starting from a known substring within the string and of m length.
        s(strfind(s,pattern)+[0:m-1])
