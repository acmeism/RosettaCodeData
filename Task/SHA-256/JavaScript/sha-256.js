const crypto = require('crypto');

const msg = 'Rosetta code';
const hash = crypto.createHash('sha256').update(msg).digest('hex');

console.log(hash);
