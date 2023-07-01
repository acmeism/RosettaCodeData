function lookAndSay( s="" ){
  var tokens=[]
  var i=0, j=1
  while( i<s.length ) {
    while( j<s.length && s[j]===s[i] ) j++
    tokens.push( `${j-i}${s[i]}` )
    i=j++
  }
  return tokens.join("")
}
var phrase="1"
for(var n=0; n<10; n++ )
  console.log( phrase = lookAndSay( phrase ) )
