$ awk 'BEGIN{for(i=0;i<6;i++){c=1;r=c;for(j=0;j<i;j++){c*=(i-j)/(j+1);r=r" "c};print r}}'
1
1 1
1 2 1
1 3 3 1
1 4 6 4 1
1 5 10 10 5 1
