  N = 100;
  [a,b] = mesgrid(1:N, 1:N);
  c     = sqrt(a.^2 + b.^2);
  [x,y] = find( c==fix(c) );
