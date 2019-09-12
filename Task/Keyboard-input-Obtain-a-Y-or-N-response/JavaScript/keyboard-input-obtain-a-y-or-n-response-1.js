const readline = require('readline');
readline.emitKeypressEvents(process.stdin);
process.stdin.setRawMode(true);

var wait_key = async function() {
  return await new Promise(function(resolve,reject) {
    var key_listen = function(str,key) {
      process.stdin.removeListener('keypress', key_listen);
      resolve(str);
    }
    process.stdin.on('keypress', key_listen);
  });
}

var done = function() {
  process.exit();
}

var go = async function() {
  do {
    console.log('Press any key...');
    var key = await wait_key();
    console.log("Key pressed is",key);
    await new Promise(function(resolve) { setTimeout(resolve,1000); });
  } while(key != 'y');
  done();
}

go();
