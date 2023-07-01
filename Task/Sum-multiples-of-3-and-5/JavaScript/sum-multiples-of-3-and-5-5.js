function sm35(n){
	return tri(n,3) + tri(n,5) - tri(n,15)
	function tri(n, f) {
		n = Math.floor((n-1) / f)
		return f * n * (n+1) / 2
	}
}
