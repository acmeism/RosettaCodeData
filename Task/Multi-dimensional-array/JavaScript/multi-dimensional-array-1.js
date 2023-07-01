function array() {
	var dimensions= Array.prototype.slice.call(arguments);
	var N=1, rank= dimensions.length;
	for (var j= 0; j<rank; j++) N*= dimensions[j];
	this.dimensions= dimensions;
	this.values= new Array(N);
}
