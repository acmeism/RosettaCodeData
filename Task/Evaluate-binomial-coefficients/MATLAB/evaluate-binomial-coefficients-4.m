function r = binomcoeff3(n,k)
   m = pascal(max(n-k,k)+1);
   r = m(n-k+1,k+1);
end;
