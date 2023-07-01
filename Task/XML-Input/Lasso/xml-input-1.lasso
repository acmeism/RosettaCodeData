// makes extracting attribute values easier
define xml_attrmap(in::xml_namedNodeMap_attr) => {
	local(out = map)
	with attr in #in
		do #out->insert(#attr->name = #attr->value)
	return #out
}

local(
	text = '<Students>
  <Student Name="April" Gender="F" DateOfBirth="1989-01-02" />
  <Student Name="Bob" Gender="M"  DateOfBirth="1990-03-04" />
  <Student Name="Chad" Gender="M"  DateOfBirth="1991-05-06" />
  <Student Name="Dave" Gender="M"  DateOfBirth="1992-07-08">
    <Pet Type="dog" Name="Rover" />
  </Student>
  <Student DateOfBirth="1993-09-10" Gender="F" Name="&#x00C9;mily" />
</Students>
',
xml = xml(#text)
)

local(
	students	= #xml -> extract('//Student'),
	names		= array
)
with student in #students do {
	#names -> insert(xml_attrmap(#student -> attributes) -> find('Name'))
}
#names -> join('<br />')
