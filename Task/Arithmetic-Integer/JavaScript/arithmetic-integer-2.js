// Invoked as node script_name.js <a> <b>. Positions 0 and 1 in the argv array contain 'node' and 'script_name.js' respectively
var a = parseInt(process.argv[2], 10);
var b = parseInt(process.argv[3], 10);

var sum = a + b;
var difference = a - b;
var product = a * b;
var division = a / b;
var remainder = a % b;  // This produces the remainder after dividing 'b' into 'a'. The '%' operator is called the 'modulo' operator

console.log('a + b = %d', sum);  // The %d syntax is a placeholder that is replaced by the sum
console.log('a - b = %d', difference);
console.log('a * b = %d', product);
console.log('a / b = %d', division);
console.log('a % b = %d', remainder);
