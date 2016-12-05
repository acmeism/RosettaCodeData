define rle(str::string)::string => {
	local(orig = #str->values->asCopy,newi=array, newc=array, compiled=string)
	while(#orig->size) => {
		if(not #newi->size) => {
			#newi->insert(1)
			#newc->insert(#orig->first)
			#orig->remove(1)
		else
			if(#orig->first == #newc->last) => {
				#newi->get(#newi->size) += 1
			else
				#newi->insert(1)
				#newc->insert(#orig->first)
			}
			#orig->remove(1)
		}
	}
	loop(#newi->size) => {
		#compiled->append(#newi->get(loop_count)+#newc->get(loop_count))
	}
	return #compiled
}
define las(n::integer,run::integer) => {
	local(str = #n->asString)
	loop(#run) => { #str = rle(#str) }
	return #str
}
loop(15) => {^ las(1,loop_count) + '\r' ^}
