RootXML = com.mathworks.xml.XMLUtils.createDocument('CharacterRemarks');
docRootNode = RootXML.getDocumentElement;
thisElement = RootXML.createElement('Character');
thisElement.setAttribute('Name','April')
thisElement.setTextContent('Bubbly: I''m > Tam and <= Emily');
docRootNode.appendChild(thisElement);
thisElement = RootXML.createElement('Character');
thisElement.setAttribute('Name','Tam O''Shanter')
thisElement.setTextContent('Burns: "When chapman billies leave the street ..."');
docRootNode.appendChild(thisElement);
thisElement = RootXML.createElement('Character');
thisElement.setAttribute('Name','Emily')
thisElement.setTextContent('Short & shrift');
docRootNode.appendChild(thisElement);
