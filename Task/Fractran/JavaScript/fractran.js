var num = new Array();
var den = new Array();
var val ;

function compile(prog){
  var regex = /\s*(\d*)\s*\/\s*(\d*)\s*(.*)/m;
  while(regex.test(prog)){
    num.push(regex.exec(prog)[1]);
    den.push(regex.exec(prog)[2]);
    prog = regex.exec(prog)[3];
  }
}

function dump(prog){
  for(var i=0; i<num.length; i++)
    document.body.innerHTML += num[i]+"/"+den[i]+" ";
  document.body.innerHTML += "<br>";
}

function step(val){
  var i=0;
  while(i<den.length && val%den[i] != 0) i++;
  return num[i]*val/den[i];
}

function exec(val){
  var i = 0;
  while(val && i<limit){
    document.body.innerHTML += i+": "+val+"<br>";
    val = step(val);
    i ++;
  }
}

// Main
compile("17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1");
dump();
var limit = 15;
exec(2);
