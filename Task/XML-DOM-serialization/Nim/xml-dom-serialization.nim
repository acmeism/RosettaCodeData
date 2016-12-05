import xmldom

var
  dom = getDOM()
  document = dom.createDocument("", "root")
  topElement = document.documentElement
  firstElement = document.createElement "element"
  textNode = document.createTextNode "Some text here"

topElement.appendChild firstElement
firstElement.appendChild textNode

echo document
