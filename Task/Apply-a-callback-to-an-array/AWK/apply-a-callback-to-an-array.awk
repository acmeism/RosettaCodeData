$ awk 'func psqr(x){print x,x*x}BEGIN{split("1 2 3 4 5",a);for(i in a)psqr(a[i])}'
4 16
5 25
1 1
2 4
3 9
