    list2 = {'AA','BB','CC'};
    for k = list2,    % list2 must be a row vector (i.e. array of size 1xn)
        printf('%s\n',k{1})
    end;
