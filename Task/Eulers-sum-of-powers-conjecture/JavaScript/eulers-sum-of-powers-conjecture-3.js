var N=1000, first=false
var npv=[], M=30 // x^5 == x modulo M (=2*3*5)
for (var n=0; n<=N; n+=1) npv[n]=Math.pow(n, 5)
var mx=1+npv[N]; while(n<=N+M) npv[n++]=mx

loop:
for (var a=1;   a<=N; a+=1)
for (var b=a+1; b<=N; b+=1)
for (var c=b+1; c<=N; c+=1)
for (var t=npv[a]+npv[b]+npv[c], d=c+1, x=t%M+d; (n=t+npv[d])<mx; d+=1, x+=1) {
	while (npv[x]<=n) x+=M; x-=M // jump over M=30 values for x>d
	if (npv[x] != n) continue
	print( [a, b, c, d, x] )
	if (first) break loop;
}
function print(c) {
	var e='<sup>5</sup>', ep=e+' + '
	document.write(c[0], ep, c[1], ep, c[2], ep, c[3], e, ' = ', c[4], e, '<br>')
}
