// ! npm install ripemd160

const ripemd160 = require('ripemd160');
// Create hash of "Rosetta Code"
const hash = new ripemd160().update('Rosetta Code').digest('hex');
console.log(hash);
