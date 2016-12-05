define cumu(n::integer) => {
	loop(-from=$cache->size,-to=#n+1) => {
		local(r = array(0), l = loop_count)
		loop(loop_count) => {
			protect => { #r->insert(#r->last + $cache->get(#l - loop_count)->get(math_min(loop_count+1, #l - loop_count))) }
		}
		#r->size > 1 ? $cache->insert(#r)
	}
	return $cache->get(#n)
}
define row(n::integer) => {
	// cache gets reset & rebuilt for each row, slower but more accurate
	var(cache = array(array(1)))
	local(r = cumu(#n+1))
	local(o = array)
	loop(#n) => {
		protect => { #o->insert(#r->get(loop_count+1) - #r->get(loop_count)) }
	}	
	return #o
}
'rows:\r'
loop(25) => {^
	loop_count + ': '+ row(loop_count)->join(' ') + '\r'
^}

'sums:\r'
with x in array(23, 123, 1234) do => {^
	var(cache = array(array(1)))
	cumu(#x+1)->last
	'\r'
^}
