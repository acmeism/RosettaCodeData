import xml.etree.ElementTree as ET

xml = open('inventory.xml').read()
doc = ET.fromstring(xml)

doc = ET.parse('inventory.xml')  # or load it directly

# Note, ElementTree's root is the top level element. So you need ".//" to really start searching from top

# Return first Item
item1 = doc.find("section/item")  # or ".//item"

# Print each price
for p in doc.findall("section/item/price"):  # or ".//price"
    print "{0:0.2f}".format(float(p.text))  # could raise exception on missing text or invalid float() conversion

# list of names
names = doc.findall("section/item/name")  # or ".//name"
