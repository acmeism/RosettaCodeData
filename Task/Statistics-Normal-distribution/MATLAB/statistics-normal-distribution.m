  N = 100000;	
  x = randn(N,1);
  mean(x)
  std(x)
  [nn,xx] = hist(x,100);
  bar(xx,nn);
