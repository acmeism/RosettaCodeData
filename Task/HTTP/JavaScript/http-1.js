const response = await fetch('http://rosettacode.org');
const text = await response.text();
console.log(text);
