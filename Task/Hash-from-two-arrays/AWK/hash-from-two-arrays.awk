$ awk 'BEGIN{split("one two three",a);
             split("1 2 3",b);
             for(i=1;i in a;i++){c[a[i]]=b[i]};
             for(i in c)print i,c[i]
             }'
three 3
two 2
one 1
