var keypress = require('keypress');

keypress(process.stdin);

process.stdin.on('keypress', function (ch, key) {
    if (key && (key.name === 'y' || key.name === 'n')) {
       console.log('Reply:' + key.name);
    }
});

process.stdin.setRawMode(true);
process.stdin.resume();
