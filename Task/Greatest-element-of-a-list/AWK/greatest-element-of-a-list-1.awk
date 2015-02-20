$ awk 'func max(a){for(i in a)if(a[i]>r)r=a[i];return r}BEGIN{a[0]=42;a[1]=33;a[2]=21;print max(a)}'
42
