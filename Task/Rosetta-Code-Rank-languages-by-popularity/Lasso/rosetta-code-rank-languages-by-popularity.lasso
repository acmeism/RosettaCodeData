<pre><code>[
sys_listtraits !>> 'xml_tree_trait' ? include('xml_tree.lasso')
local(lang = array)
local(f = curl('http://rosettacode.org/mw/index.php?title=Special:Categories&limit=5000')->result->asString)
local(ff) = xml_tree(#f)
local(lis = #ff->body->div(3)->div(3)->div(3)->div->ul->getnodes)
with li in #lis do => {
	local(title = #li->a->attribute('title'))
	#title->removeLeading('Category:')
	local(num = #li->asString->split('(')->last)
	#num->removeTrailing(')')
	#num->removeTrailing('members')
	#num->removeTrailing('member')
	#num->trim
	#num = integer(#num)
	#lang->insert(#title = #num)
}
local(c = 1)
with l in #lang
order by #l->second descending
do => {^
	#c++
	'. '+#l->second + '  - ' + #l->first+'\r'
^}
]</code></pre>
