require "xml"
str = <<-XML
<inventory title="OmniCorp Store #45x10^3">


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


</inventory>
XML

doc = XML.parse str
# Retrieve the first "item" element
first_item = doc.xpath("//item[1]")

# Perform an action on each "price" element (print it out)
doc.xpath_nodes("//price/text()").each do |price|
  puts price
end

# Get an array of all the "name" elements
names = doc.xpath_nodes("//name").to_a
