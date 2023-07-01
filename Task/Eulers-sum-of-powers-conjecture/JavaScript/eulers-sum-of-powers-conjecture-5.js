var N=1000, first=false
var is={}, ipv=[], ijs={}, ijpv=[], pow=Math.pow
for (var i=1; i<=N; i+=1) {
	var ip=pow(i,5); is[ip]=i; ipv.push(ip)
	for (var j=i+1; j<=N; j+=1) {
		var ijp=ip+pow(j,5); ijs[ijp]=[i,j]; ijpv.push(ijp)
	}
}
ijpv.sort( function (a,b) {return a - b } )
loop:
for (var i=0, ei=ipv.length; i<ei; i+=1)
for (var xp=ipv[i], j=0, je=ijpv.length; j<je; j+=1) {
	var cdp = ijpv[j]
	if (cdp >= xp) break
	var cd = ijs[xp-cdp]
	if (!cd) continue
	var ab = ijs[cdp]
	if (ab[1] >= cd[0]) continue
	print( [].concat(ab, cd, is[xp]) )
	if (first) break loop
}
function print(c) {
	var e='<sup>5</sup>', ep=e+' + '
	document.write(c[0], ep, c[1], ep, c[2], ep, c[3], e, ' = ', c[4], e, '<br>')
}
