if(sys_listunboundmethods !>> 'randomgen') => {
	define randomgen(len::integer,max::integer)::array => {
		#len <= 0 ? return
		local(out = array)
		loop(#len) => { #out->insert(math_random(#max,1)) }
		return #out
	}
}
if(sys_listunboundmethods !>> 'hasdupe') => {
	define hasdupe(a::array,threshold::integer) => {
		with i in #a do => {
			#a->find(#i)->size > #threshold-1 ? return true
		}
		
		return false
	}
}
local(threshold = 2)
local(qty = 22, probability = 0.00, samplesize = 10000)
while(#probability < 50.00) => {^
	local(dupeqty = 0)
	loop(#samplesize) => {
		local(x = randomgen(#qty,365))
		hasdupe(#x,#threshold) ? #dupeqty++
	}
	#probability = (#dupeqty / decimal(#samplesize)) * 100
	
	'Threshold: '+#threshold+', qty: '+#qty+' - probability: '+#probability+'\r'
	#qty += 1
^}
