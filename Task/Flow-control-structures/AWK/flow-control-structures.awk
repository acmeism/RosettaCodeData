$ awk 'BEGIN{for(i=1;;i++){if(i%2)continue; if(i>=10)break; print i}}'
2
4
6
8
