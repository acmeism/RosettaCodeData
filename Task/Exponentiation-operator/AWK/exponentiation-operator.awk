$ awk 'function pow(x,n){r=1;for(i=0;i<n;i++)r=r*x;return r}{print pow($1,$2)}'
2.5 2
6.25
10 6
1000000
3 0
1
