function replace(input: string, key: number) : string {
	return input.replace(/([a-z])/g,
		($1) => String.fromCharCode(($1.charCodeAt(0) + key + 26 - 97) % 26 + 97)
		).replace(/([A-Z])/g,
		($1) => String.fromCharCode(($1.charCodeAt(0) + key + 26 - 65) % 26 + 65));
}

// test
var str = 'The five boxing wizards jump quickly';
var encoded = replace(str, 3);
var decoded = replace(encoded, -3);

console.log('Enciphered: ' + encoded);
console.log('Deciphered: ' + decoded);
