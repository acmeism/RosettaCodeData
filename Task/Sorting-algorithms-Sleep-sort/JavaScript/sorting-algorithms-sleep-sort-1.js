Array.prototype.timeoutSort = function (f) {
	this.forEach(function (n) {
		setTimeout(function () { f(n) }, 5 * n)
	});
}
