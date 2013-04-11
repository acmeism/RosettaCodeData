var doc = document.implementation.createDocument( null, 'root', null );
var root = doc.documentElement;
var element = doc.createElement( 'element' );
root.appendChild( element );
element.appendChild( document.createTextNode('Some text here') );
var xmlString = new XMLSerializer().serializeToString( doc );
