array.prototype.index= function() {
	var indices= Array.prototype.slice.call(arguments);
	return this.values[tobase(this.dimensions, indices)];
}
