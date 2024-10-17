using LightXML

# Modified from the documentation for LightXML.jl. The underlying library requires an encoding string be printed.

# create an empty XML document
xdoc = XMLDocument()

# create & attach a root node
xroot = create_root(xdoc, "root")

# create the first child
xs1 = new_child(xroot, "element")

# add the inner content
add_text(xs1, "some text here")

println(xdoc)
