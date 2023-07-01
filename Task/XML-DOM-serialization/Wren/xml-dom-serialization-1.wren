class XmlDocument {
    construct new(root) {
        _root = root
    }

    toString { "<?xml version=\"1.0\" ?>\n%(_root.toString(0))" }
}

class XmlElement {
    construct new(name, text) {
        _name = name
        _text = text
        _children = []
    }

    name     { _name }
    text     { _text }
    children { _children }

    addChild(child) { _children.add(child) }

    toString(level) {
        var indent = "    "
        var s = indent * level + "<%(name)>\n"
        if (_text != "") s = s + indent * (level + 1) + _text + "\n"
        for (c in _children) {
            s = s + c.toString(level+1) + "\n"
        }
        return s + indent * level + "</%(name)>"
    }
}

var root  = XmlElement.new("root", "")
var child = XmlElement.new("element", "Some text here")
root.addChild(child)
var doc = XmlDocument.new(root)
System.print(doc)
