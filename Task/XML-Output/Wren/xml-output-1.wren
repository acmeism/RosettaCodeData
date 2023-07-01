var escapes = [
    ["&" , "&amp;"], // must do this one first
    ["\"", "&quot;"],
    ["'" , "&apos;"],
    ["<" , "&lt;"],
    [">" , "&gt;"]
]

var xmlEscape = Fn.new { |s|
    for (esc in escapes) s = s.replace(esc[0], esc[1])
    return s
}

var xmlDoc = Fn.new { |names, remarks|
    var xml = "<CharacterRemarks>\n"
    for (i in 0...names.count) {
        var name = xmlEscape.call(names[i])
        var remark = xmlEscape.call(remarks[i])
        xml = xml + "    <Character name=\"%(name)\">%(remark)</Character>\n"
    }
    xml = xml + "</CharacterRemarks>"
    System.print(xml)
}

var names = ["April", "Tam O'Shanter", "Emily"]
var remarks = [
    "Bubbly: I'm > Tam and <= Emily",
    "Burns: \"When chapman billies leave the street ...\"",
    "Short & shrift"
]
xmlDoc.call(names, remarks)
