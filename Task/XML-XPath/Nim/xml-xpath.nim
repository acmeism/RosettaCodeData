import xmldom, xmldomparser

let doc = "test3.xml".loadXMLFile.documentElement

# 1st task: retrieve the first "item" element
let i = doc.getElementsByTagName("item")[0]

# 2nd task: perform an action on each "price" element (print it out)
for j in doc.getElementsByTagName "price":
  echo j.firstChild.PText.data

# 3rd task: get an array of all the "name" elements
let namesArray = doc.getElementsByTagName "name"
