for (let i of [...Array(5000).keys()]
	.filter(n => n == n.toString().split('')
	.reduce((a, b) => a+Math.pow(parseInt(b),parseInt(b)), 0)))
    console.log(i);
