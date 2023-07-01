  function [R,S] = ffr_ffs(N)
    t = [1,0];
    T = 1;
    n = 1;
    %while T<=1000,
    while n<=N,
        R = find(t,n);
        S = find(~t,n);
        T = R(n)+S(n);

        % pre-allocate memory, this improves performance
	if T > length(t), t = [t,zeros(size(t))]; end;

        t(T) = 1;
        n = n + 1;
    end;
    if nargout>0,
      r = max(R);
      s = max(S);
    else
      printf('Sequence R:\n'); disp(R);
      printf('Sequence S:\n'); disp(S);
    end;
  end;
