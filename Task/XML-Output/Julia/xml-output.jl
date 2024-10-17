using LightXML

dialog = [("April", "Bubbly: I'm > Tam and <= Emily"),
          ("Tam O'Shanter", "Burns: \"When chapman billies leave the street ...\""),
          ("Emily", "Short & shrift")]

const xdoc = XMLDocument()
const xroot = create_root(xdoc, "CharacterRemarks")

for (name, remarks) in dialog
    xs1 = new_child(xroot, "Character")
    set_attribute(xs1, "name", name)
    add_text(xs1, remarks)
end

println(xdoc)
