import "./xsequence" for XDocument, XElement, XAttribute

var createXmlDoc = Fn.new { |names, remarks|
    var root = XElement.new("CharacterRemarks")
    for (i in 0...names.count) {
        var xe = XElement.new("Character", remarks[i])
        xe.add(XAttribute.new("name", names[i]))
        root.add(xe)
    }
    return XDocument.new(root)
}

var names = ["April", "Tam O'Shanter", "Emily"]
var remarks = [
    "Bubbly: I'm > Tam and <= Emily",
    "Burns: \"When chapman billies leave the street ...\"",
    "Short & shrift"
]
var doc = createXmlDoc.call(names, remarks)
System.print(doc)
