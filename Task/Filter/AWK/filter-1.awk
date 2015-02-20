$ awk 'BEGIN{split("1 2 3 4 5 6 7 8 9",a);for(i in a)if(!(a[i]%2))r=r" "a[i];print r}'
