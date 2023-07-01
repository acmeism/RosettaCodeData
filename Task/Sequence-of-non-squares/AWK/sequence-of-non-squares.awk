$ awk 'func f(n){return(n+int(.5+sqrt(n)))}BEGIN{for(i=1;i<=22;i++)print i,f(i)}'
1 2
2 3
3 5
4 6
5 7
6 8
7 10
8 11
9 12
10 13
11 14
12 15
13 17
14 18
15 19
16 20
17 21
18 22
19 23
20 24
21 26
22 27

$ awk 'func f(n){return(n+int(.5+sqrt(n)))}BEGIN{for(i=1;i<100000;i++){n=f(i);r=int(sqrt(n));if(r*r==n)print n"is square"}}'
$
