from lxml import etree

xml = open('inventory.xml').read()
doc = etree.fromstring(xml)

doc = etree.parse('inventory.xml')  # or load it directly

# Return first item
item1 = doc.xpath("//section[1]/item[1]")

# Print each price
for p in doc.xpath("//price"):
    print "{0:0.2f}".format(float(p.text))  # could raise exception on missing text or invalid float() conversion

names = doc.xpath("//name")  # list of names
