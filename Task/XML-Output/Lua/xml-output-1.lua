require("LuaXML")

function addNode(parent, nodeName, key, value, content)
    local node = xml.new(nodeName)
    table.insert(node, content)
    parent:append(node)[key] = value
end

root = xml.new("CharacterRemarks")
addNode(root, "Character", "name", "April", "Bubbly: I'm > Tam and <= Emily")
addNode(root, "Character", "name", "Tam O'Shanter", 'Burns: "When chapman billies leave the street ..."')
addNode(root, "Character", "name", "Emily", "Short & shrift")
print(root)
