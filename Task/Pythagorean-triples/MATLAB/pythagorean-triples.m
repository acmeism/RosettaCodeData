N=  100;
  a = 1:N;
  b = a(ones(N,1),:).^2;
  b = b+b';
  b = sqrt(b);  [y,x]=find(b==fix(b)); % test
  % here some alternative tests
  % b = b.^(1/k); [y,x]=find(b==fix(b)); % test 2
  % [y,x]=find(b==(fix(b.^(1/k)).^k));  % test 3
  % b=b.^(1/k); [y,x]=find(abs(b - round(b)) <= 4*eps*b);

  z  = sqrt(x.^2+y.^2);
  ix = (z+x+y<100) & (x < y) & (y < z);
  p  = find(gcd(x(ix),y(ix))==1);   % find primitive triples

  printf('There are %i Pythagorean Triples and %i primitive triples with a perimeter smaller than %i.\n',...
         sum(ix), length(p), N);
