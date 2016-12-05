// makes extracting attribute values easier
define xml_attrmap(in::xml_namedNodeMap_attr) => {
	local(out = map)
	with attr in #in
		do #out->insert(#attr->name = #attr->value)
	return #out
}

local(
	text = '<inventory title="OmniCorp Store #45x10^3">
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
',
xml = xml(#text)
)

local(
	items		= #xml -> extract('//item'),
	firstitem	= #items -> first,
	itemattr	= xml_attrmap(#firstitem -> attributes),
	newprices	= array
)

'<strong>First item:</strong><br />
UPC: '
#itemattr -> find('upc')
' (stock: '
#itemattr -> find('stock')
')<br />'
#firstitem -> extractone('name') -> nodevalue
' ['
#firstitem -> extractone('price') -> nodevalue
'] ('
#firstitem -> extractone('description') -> nodevalue
')<br /><br />'

with item in #items
let name = #item -> extractone('name') -> nodevalue
let price = #item -> extractone('price') -> nodevalue
do {
	#newprices -> insert(#name + ': ' + (decimal(#price) * 1.10) -> asstring(-precision = 2) + ' (' + #price + ')')
}
'<strong>Adjusted prices:</strong><br />'
#newprices -> join('<br />')
'<br /><br />'
'<strong>Array with all names:</strong><br />'
#xml -> extract('//name') -> asstaticarray
