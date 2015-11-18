function luhn(str){
	return str.split('').reduceRight(function(prev, curr, idx){
		prev = parseInt(prev, 10);
		if ((idx + 1) % 2 !== 0) {
			curr = (curr * 2).toString().split('').reduce(function(p, c){ return parseInt(p, 10) + parseInt(c, 10)});
		}
		return prev + parseInt(curr, 10);
	}) % 10 === 0;
}
