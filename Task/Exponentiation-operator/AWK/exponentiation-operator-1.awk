$ awk 'function pow(x,n){r=1;for(i=0;i<n;i++)r=r*x;return r}{print pow($1,$2)}'
