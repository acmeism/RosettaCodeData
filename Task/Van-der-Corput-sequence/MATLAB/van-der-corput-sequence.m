    function x = corput (n)
    b = dec2bin(1:n)-'0';   % generate sequence of binary numbers from 1 to n
    l = size(b,2);          % get number of binary digits
    w = (1:l)-l-1;          % 2.^w are the weights
    x = b * ( 2.^w');       % matrix times vector multiplication for
    end;
