#!/usr/bin/awk -f
BEGIN {
    split("cul-de-sac",a,"-")
    split("1-2-3",b,"-")
    concat_array(a,b,c)

    for (i in c) {
        print i,c[i]
    }
}

function concat_array(a,b,c) {
    for (i in a) {
        c[++nc]=a[i]	
    }
    for (i in b) {
       c[++nc]=b[i]	
    }
}
