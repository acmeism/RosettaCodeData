FileRead, inventory, xmlfile.xml

RegExMatch(inventory, "<item.*?</item>", item1)
MsgBox % item1

pos = 1
While, pos := RegExMatch(inventory, "<price>(.*?)</price>", price, pos + 1)
  MsgBox % price1

While, pos := RegExMatch(inventory, "<name>.*?</name>", name, pos + 1)
  names .= name . "`n"
MsgBox % names
