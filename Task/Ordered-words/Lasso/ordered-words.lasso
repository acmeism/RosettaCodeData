local(f = file('unixdict.txt'), words = array, ordered = array, maxleng = 0)
#f->dowithclose => {
	#f->foreachLine => {
		#words->insert(#1)
	}
}
with w in #words
do => {
	local(tosort = #w->asString->values)
	#tosort->sort
	if(#w->asString == #tosort->join('')) => {
		#ordered->insert(#w->asString)
		#w->asString->size > #maxleng ? #maxleng = #w->asString->size
	}
}
with w in #ordered
where #w->size == #maxleng
do => {^ #w + '\r' ^}
