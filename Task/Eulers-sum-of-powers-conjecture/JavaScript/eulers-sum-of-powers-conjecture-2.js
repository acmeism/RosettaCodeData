var N=1000, first=false
var ns={}, npv=[]
for (var n=0; n<=N; n++) {
	var np=Math.pow(n,5); ns[np]=n; npv.push(np)
}
loop:
for (var a=1;   a<=N; a+=1)
for (var b=a+1; b<=N; b+=1)
for (var c=b+1; c<=N; c+=1)
for (var d=c+1; d<=N; d+=1) {
	var x = ns[ npv[a]+npv[b]+npv[c]+npv[d] ]
	if (!x) continue
	print( [a, b, c, d, x] )
	if (first) break loop
}
function print(c) {
	var e='<sup>5</sup>', ep=e+' + '
	document.write(c[0], ep, c[1], ep, c[2], ep, c[3], e, ' = ', c[4], e, '<br>')
}
