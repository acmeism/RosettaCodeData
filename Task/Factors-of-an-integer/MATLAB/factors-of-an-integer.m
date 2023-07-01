  function fact(n);
    f = factor(n);	% prime decomposition
    K = dec2bin(0:2^length(f)-1)-'0';   % generate all possible permutations
    F = ones(1,2^length(f));	
    for k = 1:size(K)
      F(k) = prod(f(~K(k,:)));		% and compute products
    end;
    F = unique(F);	% eliminate duplicates
    printf('There are %i factors for %i.\n',length(F),n);
    disp(F);
  end;
