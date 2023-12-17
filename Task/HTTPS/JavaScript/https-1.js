const response = await fetch('https://rosettacode.org');
const text = await response.text();
console.log(text);
