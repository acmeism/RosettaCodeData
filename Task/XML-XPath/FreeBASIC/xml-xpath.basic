Dim As String XML, item, price, nombre
Dim As Integer P1, P2

'' Read the XML file
Open "test3.xml" For Input As #1
XML = Input(Lof(1), #1)
Close #1

'' Find the first 'item' element
P1 = Instr(XML, "<item ")
P2 = Instr(XML, "</item>")
item = Mid(XML, P1, P2-P1+7)
Print "The first 'item' element is:"
Print item

'' Find all 'price' elements
Print "The 'prices' are:"
P1 = 1
Do
    P1 = Instr(P1, XML, "<price>")
    If P1 = 0 Then Exit Do
    P2 = Instr(P1, XML, "</price>")
    price = Mid(XML, P1+7, P2-P1-7)
    Print price
    P1 = P2 + 1
Loop

'' Find all 'nombre' elements
Print !"\nThe 'names' are:"
P1 = 1
Do
    P1 = Instr(P1, XML, "<name>")
    If P1 = 0 Then Exit Do
    P2 = Instr(P1, XML, "</name>")
    nombre = Mid(XML, P1+6, P2-P1-6)
    Print nombre
    P1 = P2 + 1
Loop

Sleep
