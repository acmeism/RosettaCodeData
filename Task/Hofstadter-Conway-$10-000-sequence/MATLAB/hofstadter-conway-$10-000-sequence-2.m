NN = 20;
Q = HCsequence(2^NN+1);
V = Q./(1:2^NN);
for k=1:NN,
  [m,i] = max(V(2^k:2^(k+1)));
  i = i + 2^k - 1;
  printf('Maximum between 2^%i and 2^%i is %f at n=%i\n',k,k+1,m,i);
end;
