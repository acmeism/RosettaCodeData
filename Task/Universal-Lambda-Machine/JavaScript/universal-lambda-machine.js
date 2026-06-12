#!/usr/local/bin/node --stack-size=8192
let bytemode = process.argv.length <= 2;
var data;
var nchar = 0;
var nbit = 0;
var progchar;

function bit2lam(bit) {
  return function(x0) { return function(x1) { return bit ? x1 : x0 } }
}
function byte2lam(bits,n) {
  return n==0 ? (function(_) { return function(y) { return y } }) // nil
              : (function(z) { return z (bit2lam((bits>>(n-1))&1))
                                        (byte2lam(bits,n-1)) })  // cons bitn bits>n
}
function input(n) {           // input from n'th character onward
  if (n >= data.length)
    return function(z) { { return function(y) { return y } } }     // nil
  let c = data[n];
  return function(z) { return z (bytemode ? byte2lam(c,8) : bit2lam(c&1)) (input(n+1)) } // cons charn chars>n
}
function lam2bit(lambit) {
  return lambit(function(_){return 0})(function(_){return 1})()  // force suspension
}
function lam2byte(lambits, x) {
  return lambits(function(lambit) {
           return function(lamtail) {
             return function(_) { return lam2byte(lamtail, 2*x + lam2bit(lambit)) }
           }
         })(Buffer.from([x]))              // end of byte
}
function output(prog) {
  return prog(function(c) {      // more chars
    process.stdout.write(bytemode ? lam2byte(c,0) : lam2bit(c) ? '1' : '0');
    return function(tail) {
      return function(_) { return output(tail) }
    }
  })(0)                         // end of output
}
function getbit() {
  if (nbit==0) {
    progchar = data[nchar++];
    nbit = bytemode ? 8 : 1;
  }
  return (progchar >> --nbit) & 1;
}
function program() {
  if (getbit()) {               // variable
    var i = 0;
    while (getbit()==1) { i++ }
    return function() { return arguments[i] }
  } else if (getbit()) {        // application
    let p = program();
    let q = program();
    return function(...args) {
      return p(...args)(function(arg) { return q(...args)(arg) }) // suspend argument
    }
  } else {
    let p = program();
    return function(...args) {
      return function(arg) { return p(arg, ...args) }  // extend environment with one more argument
    }
  }
}
process.stdin.on('readable', () => {
  if ((data = process.stdin.read()) != null) {
    prog = program()();
    output(prog(input(nchar)))             // run program with empty env on input
  }
});
