Set objXMLDoc = CreateObject("msxml2.domdocument")

Set objRoot = objXMLDoc.createElement("CharacterRemarks")
objXMLDoc.appendChild objRoot

Call CreateNode("April","Bubbly: I'm > Tam and <= Emily")
Call CreateNode("Tam O'Shanter","Burns: ""When chapman billies leave the street ...""")
Call CreateNode("Emily","Short & shrift")

objXMLDoc.save("C:\Temp\Test.xml")

Function CreateNode(attrib_value,node_value)
	Set objNode = objXMLDoc.createElement("Character")
	objNode.setAttribute "name", attrib_value
	objNode.text = node_value
	objRoot.appendChild objNode
End Function
