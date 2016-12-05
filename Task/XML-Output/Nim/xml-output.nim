import xmltree, strtabs, sequtils

proc charsToXML(names, remarks): XmlNode =
  result = <>CharacterRemarks()
  for name, remark in items zip(names, remarks):
    result.add(<>Character(name=name, remark.newText))

echo charsToXML(@["April", "Tam O'Shanter", "Emily"],
  @["Bubbly: I'm > Tam and <= Emily",
    "Burns: \"When chapman billies leave the street ...\"",
    "Short & shrift"])
