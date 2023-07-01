var N=1000, first=false
var dxs={}, pow=Math.pow
for (var d=1; d<=N; d+=1)
	for (var dp=pow(d,5), x=d+1; x<=N; x+=1)
		dxs[pow(x,5)-dp]=[d,x]
loop:
for (var a=1; a<N; a+=1)
for (var ap=pow(a,5), b=a+1; b<N; b+=1)
for (var abp=ap+pow(b,5), c=b+1; c<N; c+=1) {
	var dx = dxs[ abp+pow(c,5) ]
	if (!dx || c >= dx[0]) continue
	print( [a, b, c].concat( dx ) )
	if (first) break loop
}
function print(c) {
	var e='<sup>5</sup>', ep=e+' + '
	document.write(c[0], ep, c[1], ep, c[2], ep, c[3], e, ' = ', c[4], e, '<br>')
}
