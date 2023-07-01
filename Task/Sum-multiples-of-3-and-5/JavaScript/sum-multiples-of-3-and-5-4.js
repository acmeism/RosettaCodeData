function sm35(n){
	var s=0, inc=[3,2,1,3,1,2,3]
	for (var j=6, i=0; i<n; j+=j==6?-j:1, i+=inc[j]) s+=i
	return s
}
