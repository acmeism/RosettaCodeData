function createRandomBracketSequence(maxlen)
{
   var chars = { '0' : '[' , '1' : ']' };
   function getRandomInteger(to)
   {
      return Math.floor(Math.random() * (to+1));
   }
   var n = getRandomInteger(maxlen);
   var result = [];
   for(var i = 0; i < n; i++)
   {
     result.push(chars[getRandomInteger(1)]);
   }
   return result.join("");
}

function bracketsAreBalanced(s)
{
  var open = (arguments.length > 1) ? arguments[1] : '[';
  var close = (arguments.length > 2) ? arguments[2] : ']';
  var c = 0;
  for(var i = 0; i < s.length; i++)
  {
    var ch = s.charAt(i);
    if ( ch == open )
    {
      c++;
    }
    else if ( ch == close )
    {
      c--;
      if ( c < 0 ) return false;
    }
  }
  return c == 0;
}

var c = 0;
while ( c < 5 ) {
  var seq = createRandomBracketSequence(8);
  alert(seq + ':\t' + bracketsAreBalanced(seq));
  c++;
}
