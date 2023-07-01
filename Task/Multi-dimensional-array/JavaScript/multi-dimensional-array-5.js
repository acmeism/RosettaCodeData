function array(length) {
	var rest= Array.prototype.slice.call(arguments);
	var r= new Array(length);
	if (0<rest.length) {
		for (var j= 0; j<length; j++) {
			r[j]= array.apply(rest);
		}
	}
}
