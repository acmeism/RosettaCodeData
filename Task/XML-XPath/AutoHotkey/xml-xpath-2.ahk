#Include xpath.ahk

xpath_load(doc, "xmlfile.xml")

; Retrieve the first "item" element
MsgBox % xpath(doc, "/inventory/section[1]/item[1]/text()")

; Perform an action on each "price" element (print it out)
prices := xpath(doc, "/inventory/section/item/price/text()")
Loop, Parse, prices,`,
  reordered .= A_LoopField "`n"
MsgBox % reordered

; Get an array of all the "name" elements
MsgBox % xpath(doc, "/inventory/section/item/name")
