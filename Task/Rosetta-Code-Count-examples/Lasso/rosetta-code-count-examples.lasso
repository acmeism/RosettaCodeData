local(root = json_deserialize(curl('http://rosettacode.org/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=10&format=json')->result))
local(tasks = array, title = string, urltitle = string, thiscount = 0, totalex = 0)
with i in #root->find('query')->find('categorymembers') do => {^
	#thiscount = 0
	#title = #i->find('title')
	#urltitle = #i->find('title')
	#urltitle->replace(' ','_')
	
	#title+': '
	local(src = curl('http://rosettacode.org/mw/index.php?title='+#urltitle->asBytes->encodeurl+'&action=raw')->result->asString)
	#thiscount = (#src->split('=={{header|'))->size - 1
	#thiscount < 0 ? #thiscount = 0
	#thiscount + ' examples.'
	#totalex += #thiscount
	'\r'
^}
'Total: '+#totalex+' examples.'
