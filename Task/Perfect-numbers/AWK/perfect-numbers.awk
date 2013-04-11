$ awk 'func perf(n){s=0;for(i=1;i<n;i++)if(n%i==0)s+=i;return(s==n)}
BEGIN{for(i=1;i<10000;i++)if(perf(i))print i}'
6
28
496
8128
