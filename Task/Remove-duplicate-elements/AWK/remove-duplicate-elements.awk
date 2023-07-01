$ awk 'BEGIN{split("a b c d c b a",a);for(i in a)b[a[i]]=1;r="";for(i in b)r=r" "i;print r}'
a b c d
