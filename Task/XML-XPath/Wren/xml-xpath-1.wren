import "/pattern" for Pattern

var doc = """
<inventory title="OmniCorp Store #45x10^3">
  <section name="health">
    <item upc="123456789" stock="12">
      <name>Invisibility Cream</name>
      <price>14.50</price>
      <description>Makes you invisible</description>
    </item>
    <item upc="445322344" stock="18">
      <name>Levitation Salve</name>
      <price>23.99</price>
      <description>Levitate yourself for up to 3 hours per application</description>
    </item>
  </section>
  <section name="food">
    <item upc="485672034" stock="653">
      <name>Blork and Freen Instameal</name>
      <price>4.95</price>
      <description>A tasty meal in a tablet; just add water</description>
    </item>
    <item upc="132957764" stock="44">
      <name>Grob winglets</name>
      <price>3.56</price>
      <description>Tender winglets of Grob. Just add water</description>
    </item>
  </section>
</inventory>
"""

var p1 = Pattern.new("<item ")
var match1 = p1.find(doc)
var p2 = Pattern.new("<//item>")
var match2 = p2.find(doc)
System.print("The first 'item' element is:")
System.print("    " + doc[match1.index..match2.index + 6])

var p3 = Pattern.new("<price>[+1^<]<//price>")
var matches = p3.findAll(doc)
System.print("\nThe 'prices' are:")
for (m in matches) System.print(m.captures[0].text)

var p4 = Pattern.new("<name>[+1^<]<//name>")
var matches2 = p4.findAll(doc)
var names = matches2.map { |m| m.captures[0].text }.toList
System.print("\nThe 'names' are:")
System.print(names.join("\n"))
