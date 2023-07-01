define character2xml(names::array, remarks::array) => {

	fail_if(#names -> size != #remarks -> size, -1, 'Input arrays not of same size')

	local(
		domimpl = xml_domimplementation,
		doctype = #domimpl -> createdocumenttype(
			'svg:svg',
			'-//W3C//DTD SVG 1.1//EN',
			'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'
		),
		character_xml = #domimpl -> createdocument(
			'http://www.w3.org/2000/svg',
			'svg:svg',
			#docType
		),
		csnode = #character_xml -> createelement('CharacterRemarks'),
		charnode
	)

	#character_xml -> appendChild(#csnode)

	loop(#names -> size) => {
		#charnode = #character_xml -> createelement('Character')
		#charnode -> setAttribute('name', #names  -> get(loop_count))
		#charnode -> nodeValue = encode_xml(#remarks -> get(loop_count))
		#csnode -> appendChild(#charnode)
	}
	return #character_xml

}

character2xml(
	array(`April`, `Tam O'Shanter`, `Emily`),
	array(`Bubbly: I'm > Tam and <= Emily`, `Burns: "When chapman billies leave the street ..."`, `Short & shrift`)
)
