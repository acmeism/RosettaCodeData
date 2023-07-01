import "./xsequence" for XDocument, XElement

var doc = XDocument.new(
    XElement.new("root",
        XElement.new("element", "Some text here")
    )
)
System.print(doc)
