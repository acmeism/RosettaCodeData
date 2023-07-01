open System.IO
open System.Xml.XPath

let xml = new StringReader("""
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
""")

let nav = XPathDocument(xml).CreateNavigator()

// first "item"; throws if none exists
let item = nav.SelectSingleNode(@"//item[1]")

// apply a operation (print text value) to all price elements
for price in nav.Select(@"//price") do
    printfn "%s" (price.ToString())

// array of all name elements
let names = seq { for name in nav.Select(@"//name") do yield name } |> Seq.toArray
