//create XMLDocument object from file
var xhr = new XMLHttpRequest();
xhr.open('GET', 'file.xml', false);
xhr.send(null);
var doc = xhr.responseXML;

//get first <item> element
var firstItem = doc.evaluate( '//item[1]', doc, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null ).singleNodeValue;
alert( firstItem.textContent );

//output contents of <price> elements
var prices = doc.evaluate( '//price', doc, null, XPathResult.ANY_TYPE, null );
for( var price = prices.iterateNext(); price != null; price = prices.iterateNext() ) {
  alert( price.textContent );
}

//add <name> elements to array
var names = doc.evaluate( '//name', doc, null, XPathResult.ANY_TYPE, null);
var namesArray = [];
for( var name = names.iterateNext(); name != null; name = names.iterateNext() ) {
  namesArray.push( name );
}
alert( namesArray );
