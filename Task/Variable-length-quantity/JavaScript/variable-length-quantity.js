const RADIX = 7;
const MASK = 2**RADIX - 1;

const octetify = (n)=> {
	if (n >= 2147483648) {
		throw new RangeError("Variable Length Quantity not supported for numbers >= 2147483648");
	}
	const octets = [];
	for (let i = n; i != 0; i >>>= RADIX) {
		octets.push((((i & MASK) + (octets.empty ? 0 : (MASK + 1)))));
	}
	octets.reverse();
	return octets;
};

const deoctetify = (octets)=>
	octets.reduce((n, octet)=>
		(n << RADIX) + (octet & MASK)
	, 0);

// Test (assuming Node.js)

const assert = require("assert");
const testNumbers = [ 0x200000, 0x1fffff, 1, 127, 128, 2147483647 /*, 589723405834*/ ]

testNumbers.forEach((number)=> {
	const octets = octetify(number)
	console.log(octets);
	const got_back_number = deoctetify(octets)
	assert.strictEqual(got_back_number, number);
});
