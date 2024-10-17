using LibExpat

xdoc = raw"""<inventory title="OmniCorp Store #45x10^3">
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

debracket(s) = replace(s, r".+\>(.+)\<.+" => s"\1")

etree = xp_parse(xdoc)
firstshow = LibExpat.find(etree, "//item")[1]
println("The first item's node XML entry is:\n", firstshow, "\n\n")

prices = LibExpat.find(etree, "//price")
println("Prices:")
for p in prices
    println("\t", debracket(string(p)))
end
println("\n")

namearray = LibExpat.find(etree, "//name")
println("Array of names of items:\n\t", map(s -> debracket(string(s)), namearray))
