define getmode(a::array)::array => {
	local(mmap = map, maxv = 0, modes = array)
	// store counts
	with e in #a do => { #mmap->keys >> #e ? #mmap->find(#e) += 1 | #mmap->insert(#e = 1) }
	// get max value
	with e in #mmap->keys do => { #mmap->find(#e) > #maxv ? #maxv = #mmap->find(#e) }
	// get modes with max value
	with e in #mmap->keys where #mmap->find(#e) == #maxv do => { #modes->insert(#e) }
	return #modes
}
getmode(array(1,3,6,6,6,6,7,7,12,12,17))
getmode(array(1,3,6,3,4,8,9,1,2,3,2,2))
