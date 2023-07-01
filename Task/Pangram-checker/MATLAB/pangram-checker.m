function trueFalse = isPangram(string)
    % X is a histogram of letters
    X = sparse(abs(lower(string)),1,1,128,1);
    trueFalse = full(all(X('a':'z') > 0));
end
