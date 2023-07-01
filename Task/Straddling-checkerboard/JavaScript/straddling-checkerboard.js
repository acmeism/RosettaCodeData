<script>
var alphabet=new Array("ESTONIA  R","BCDFGHJKLM","PQUVWXYZ./") // scramble alphabet as you wish
var prefixes=new Array("",alphabet[0].indexOf(" "),alphabet[0].lastIndexOf(" "))

function straddle(message){
  var out=""
  message=message.toUpperCase()
  message=message.replace(/([0-9])/g,"/$1") // dumb way to escape numbers
  for(var i=0;i<message.length;i++){
    var chr=message[i]
	if(chr==" ")continue
	for(var j=0;j<3;j++){
	  var k=alphabet[j].indexOf(chr)
	  if(k<0)continue
	  out+=prefixes[j].toString()+k
	}
	if(chr=="/")out+=message[++i]
  }
  return out
}

function unstraddle(message){
  var out=""
  var n,o
  for(var i=0;i<message.length;i++){
	n=message[i]*1
    switch(n){
	  case prefixes[1]: o=alphabet[1][message[++i]];break
	  case prefixes[2]: o=alphabet[2][message[++i]];break
	  default: o=alphabet[0][n]
	}
	o=="/"?out+=message[++i]:out+=o
  }
  return out
}

str="One night-it was on the twentieth of March, 1888-I was returning."
document.writeln(str)
document.writeln(straddle(str))
document.writeln(unstraddle(straddle(str)))
</script>
