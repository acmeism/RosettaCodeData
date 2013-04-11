$ awk 'func sum(s){split(s,a);r=0;for(i in a)r+=a[i];return r}{print sum($0)}'
1 2 3 4 5 6 7 8 9 10
55

$ awk 'func prod(s){split(s,a);r=1;for(i in a)r*=a[i];return r}{print prod($0)}'
1 2 3 4 5 6 7 8 9 10
3628800
