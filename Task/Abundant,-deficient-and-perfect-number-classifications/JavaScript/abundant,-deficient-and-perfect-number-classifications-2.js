for (var dpa=[1,0,0], n=2; n<=20000; n+=1) {
	for (var ds=1, d=2, e=Math.sqrt(n); d<e; d+=1) if (n%d==0) ds+=d+n/d
	if (n%e==0) ds+=e
	dpa[ds<n ? 0 : ds==n ? 1 : 2]+=1
}
document.write('Deficient:',dpa[0], ', Perfect:',dpa[1], ', Abundant:',dpa[2], '<br>' )
