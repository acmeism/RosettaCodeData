RootXML = com.mathworks.xml.XMLUtils.createDocument('Students');
docRootNode = RootXML.getDocumentElement;
thisElement = RootXML.createElement('Student');
thisElement.setAttribute('Name','April')
thisElement.setAttribute('Gender','F')
thisElement.setAttribute('DateOfBirth','1989-01-02')
docRootNode.appendChild(thisElement);
thisElement = RootXML.createElement('Student');
thisElement.setAttribute('Name','Bob')
thisElement.setAttribute('Gender','M')
thisElement.setAttribute('DateOfBirth','1990-03-04')
docRootNode.appendChild(thisElement);
thisElement = RootXML.createElement('Student');
thisElement.setAttribute('Name','Chad')
thisElement.setAttribute('Gender','M')
thisElement.setAttribute('DateOfBirth','1991-05-06')
docRootNode.appendChild(thisElement);
thisElement = RootXML.createElement('Student');
thisElement.setAttribute('Name','Dave')
thisElement.setAttribute('Gender','M')
thisElement.setAttribute('DateOfBirth','1992-07-08')
node = RootXML.createElement('Pet');
node.setAttribute('Type','dog')
node.setAttribute('name','Rover')
thisElement.appendChild(node);
docRootNode.appendChild(thisElement);
thisElement = RootXML.createElement('Student');
thisElement.setAttribute('Name','Émily')
thisElement.setAttribute('Gender','F')
thisElement.setAttribute('DateOfBirth','1993-09-10')
docRootNode.appendChild(thisElement);
clearvars -except RootXML

for I=0:1:RootXML.getElementsByTagName('Student').item(0).getAttributes.getLength-1
    if strcmp(RootXML.getElementsByTagName('Student').item(0).getAttributes.item(I).getName,'Name')
        tag=I;
        break
    end
end

for I=0:1:RootXML.getElementsByTagName('Student').getLength-1
    disp(RootXML.getElementsByTagName('Student').item(I).getAttributes.item(tag).getValue)
end
