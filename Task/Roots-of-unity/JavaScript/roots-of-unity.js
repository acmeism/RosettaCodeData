function Root(angle) {
	with (Math) { this.r = cos(angle); this.i = sin(angle) }
}

Root.prototype.toFixed = function(p) {
	return this.r.toFixed(p) + (this.i >= 0 ? '+' : '') + this.i.toFixed(p) + 'i'
}

function roots(n) {
	var rs = [], teta = 2*Math.PI/n
	for (var angle=0, i=0; i<n; angle+=teta, i+=1) rs.push( new Root(angle) )
	return rs
}

for (var n=2; n<8; n+=1) {
	document.write(n, ': ')
	var rs=roots(n); for (var i=0; i<rs.length; i+=1) document.write( i ? ', ' : '', rs[i].toFixed(5) )
	document.write('<br>')
}
