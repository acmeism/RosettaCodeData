let Pistol = function(method) {
  this.fired = false;
  this.cylinder = new Array(6).fill(false);
  this.trigger = 0;
  this.rshift = function() {
    this.trigger = this.trigger == 0 ? 5 : this.trigger-1;
  }
  this.load = function() {
    while (this.cylinder[this.trigger]) this.rshift();
    this.cylinder[this.trigger] = true;
    this.rshift();
  }
  // actually we don't need this here: just for completeness
  this.unload = function() { this.cylinder.fill(false); }

  this.spin = function() { this.trigger = Math.floor(Math.random() * 6); }
  this.fire = function() {
    if (this.cylinder[this.trigger]) this.fired = true;
    this.rshift();
  }
  this.exec = function() {
    if (!method) console.error('No method provided');
    else {
      method = method.toUpperCase();
      for (let x = 0; x < method.length; x++)
        switch (method[x]) {
          case 'F' : this.fire(); break;
          case 'L' : this.load(); break;
          case 'S' : this.spin(); break;
          case 'U' : this.unload(); break;
          default: console.error(`Unknown character in method: ${method[x]}`);
        }
      return this.fired;
    }
  }
}

// simulating
const ITERATIONS = 25e4;
let methods = 'lslsfsf lslsff llsfsf llsff'.split(' '),
    bodyCount;
console.log(`@ ${ITERATIONS.toLocaleString('en')} iterations:`);
console.log();
for (let x = 0; x < methods.length; x++) {
  bodyCount = 0;
  for (let y = 1; y <= ITERATIONS; y++)
    if (new Pistol(methods[x]).exec()) bodyCount++;
  console.log(`${methods[x]}:`);
  console.log(`deaths: ${bodyCount.toLocaleString('en')} (${(bodyCount / ITERATIONS * 100).toPrecision(3)} %) `);
  console.log();
}
