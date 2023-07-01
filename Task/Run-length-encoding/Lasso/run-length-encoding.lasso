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
define rlde(str::string)::string => {
	local(o = string)
	while(#str->size) => {
		loop(#str->size) => {
			if(#str->isualphabetic(loop_count)) => {
				if(loop_count == 1) => {
					#o->append(#str->get(loop_count))
					#str->removeLeading(#str->get(loop_count))
					loop_abort
				}
				local(num = integer(#str->substring(1,loop_count)))
				#o->append(#str->get(loop_count)*#num)
				#str->removeLeading(#num+#str->get(loop_count))
				loop_abort
			}
		}
	}
	return #o
}
//Tests:
rle('WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW')
rle('dsfkjhhkdsjfhdskhshdjjfhhdlsllw')

rlde('12W1B12W3B24W1B14W')
rlde('1d1s1f1k1j2h1k1d1s1j1f1h1d1s1k1h1s1h1d2j1f2h1d1l1s2l1w')
