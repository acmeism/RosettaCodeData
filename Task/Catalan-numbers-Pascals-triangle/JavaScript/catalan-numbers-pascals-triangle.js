var n=15
for (var t=[0,1], i=1; i<=n; i++) {
	for (var j=i; j>1; j--) t[j] += t[j-1]
	t[i+1] = t[i];
	for (var j=i+1; j>1; j--) t[j] += t[j-1]
	document.write(i==1 ? '' : ', ', t[i+1] - t[i])
}
