#!/usr/bin/awk -f
BEGIN {
   if (p<1) {p = 1};
}

function diff(s, p) {
    # pascal triangled with sign changes	
    b[1] = (p%2) ? 1 : -1;
    for (j=1; j < p; j++) {
        b[j+1] = -b[j]*(p-j)/j;
    };

    n = split(s, a, " ");
    s = "";
    for (j = 1; j <= n-p+1; j++) {
        c = 0;
        for(i = 1; i <= p; i++) {
            c += b[i]*a[j+i-1];
        }
        s = s" "c;
    }
    return s;	
}

{
   print diff($0, p);
}
