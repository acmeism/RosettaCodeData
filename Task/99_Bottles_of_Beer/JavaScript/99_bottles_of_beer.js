// Line breaks are in HTML
var beer = 99;
while (beer > 0)
{
 document.write( beer + " bottles of beer on the wall<br>" );
 document.write( beer + " bottles of beer<br>" );
 document.write( "Take one down, pass it around<br>" );
 document.write( (beer - 1) + " bottles of beer on the wall<br>" );
 beer--;
}
