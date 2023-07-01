docNode = com.mathworks.xml.XMLUtils.createDocument('root');
docRootNode = docNode.getDocumentElement;
thisElement = docNode.createElement('element');
thisElement.appendChild(docNode.createTextNode('Some text here'));
docRootNode.appendChild(thisElement);
