$ awk 'func r(){return sqrt(-2*log(rand()))*cos(6.2831853*rand())}BEGIN{for(i=0;i<1000;i++)s=s" "1+0.5*r();print s}'
