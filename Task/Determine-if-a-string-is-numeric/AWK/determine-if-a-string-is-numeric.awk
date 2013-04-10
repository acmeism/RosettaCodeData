$ awk 'function isnum(x){return(x==x+0)}BEGIN{print isnum("hello"),isnum("-42")}'
0 1
