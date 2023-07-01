library("XML")
doc <- xmlInternalTreeParse("test3.xml")

# Retrieve the first "item" element
getNodeSet(doc, "//item")[[1]]

# Perform an action on each "price" element
sapply(getNodeSet(doc, "//price"), xmlValue)

# Get an array of all the "name" elements
sapply(getNodeSet(doc, "//name"), xmlValue)
