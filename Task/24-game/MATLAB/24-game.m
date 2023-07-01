  function twentyfour()
  N = 4;
  n = ceil(rand(1,N)*9);
  printf('Generate a equation with the numbers %i, %i, %i, %i and +, -, *, /, () operators ! \n',n);
  s = input(': ','s');
  t = s;
  for k = 1:N,
    [x,t] = strtok(t,'+-*/() \t');
     if length(x)~=1,
       error('invalid sign %s\n',x);
     end;
     y = x-'0';
     if ~(0 < y & y < 10)
       error('invalid sign %s\n',x);
     end;
     z(1,k) = y;  	
  end;
  if any(sort(z)-sort(n))
    error('numbers do not match.\n');	
  end;

  val =  eval(s);
  if val==24,
    fprintf('expression "%s" results in %i.\n',s,val);	
  else
    fprintf('expression "%s" does not result in 24 but %i.\n',s,val);
  end; 	
