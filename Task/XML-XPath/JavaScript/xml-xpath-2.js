//create XML object from file
var xhr = new XMLHttpRequest();
xhr.open('GET', 'file.xml', false);
xhr.send(null);
var doc = new XML(xhr.responseText);

//get first <item> element
var firstItem = doc..item[0];
alert( firstItem );

//output contents of <price> elements
for each( var price in doc..price ) {
  alert( price );
}

//add <name> elements to array
var names = [];
for each( var name in doc..name ) {
  names.push( name );
}
alert( names );
