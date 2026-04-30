Set objXMLDoc = CreateObject("msxml2.domdocument")

objXMLDoc.load("In.xml")

Set item_nodes = objXMLDoc.selectNodes("//item")
i = 1
For Each item In item_nodes
	If i = 1 Then
		WScript.StdOut.Write item.xml
		WScript.StdOut.WriteBlankLines(2)
		Exit For
	End If
Next

Set price_nodes = objXMLDoc.selectNodes("//price")
list_price = ""
For Each price In price_nodes
	list_price = list_price & price.text & ", "
Next
WScript.StdOut.Write list_price
WScript.StdOut.WriteBlankLines(2)

Set name_nodes = objXMLDoc.selectNodes("//name")
list_name = ""
For Each name In name_nodes
	list_name = list_name & name.text & ", "
Next
WScript.StdOut.Write list_name
WScript.StdOut.WriteBlankLines(2)
