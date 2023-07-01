// not using XML or Xpath
'<hr />'
local(
	regexp	= regexp(-find = `<Student.*?Name="(.*?)"`, -input = #text, -ignoreCase),
	names	= array
)

while( #regexp -> find) => {
	#names -> insert(#regexp -> matchstring(1))
}
#names -> join('<br />')
