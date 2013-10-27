(function(){var beer = 99,string='';
while (beer > 0)
{
 string+=beer+"bottles of beer on the wall\n"+ //inline line appending shouldn't be as expensive.
 beer +
 "bottles of beer\nTake one down, pass it around\n"+
 (--beer)+
 " bottles of beer on the wall\n" ;

}
console.log(string);
})()
