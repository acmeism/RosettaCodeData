% remove trailing whitespaces
    str = str(1:find(~isspace(str),1,'last'));
% remove leading whitespaces
    str = str(find(~isspace(str),1):end);

% removes leading and trailing whitespaces, vectorized version
    f = ~isspace(str);
    str = str(find(f,1,'first'):find(f,1,'last');

% a built-in function, removes leading and trailing whitespaces
    str = strtrim(str);
