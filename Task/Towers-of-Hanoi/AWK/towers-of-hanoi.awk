$ awk 'func hanoi(n,f,t,v){if(n>0){hanoi(n-1,f,v,t);print(f,"->",t);hanoi(n-1,v,t,f)}}
BEGIN{hanoi(4,"left","middle","right")}'
