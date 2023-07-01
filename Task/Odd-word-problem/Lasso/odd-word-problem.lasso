define odd_word_processor(str::string) => {
	local(
		isodd 		= false,
		pos 		= 1,
		invpos	 	= 1,
		lastpos		= 1
	)
	while(#str->get(#pos) != '.' && #pos <= #str->size) => {
		if(not #str->isAlpha(#pos)) => {
			not #isodd ? #isodd = true | #isodd = false	
		}
		if(#isodd) => {
			#lastpos = 1
			#invpos = 1
			while(#str->isAlpha(#pos+#lastpos) && #pos+#lastpos <= #str->size) => {
				#lastpos++
			}
			'odd lastpos: '+#lastpos+'\r'
			local(maxpos = #pos+#lastpos-1)
			while(#invpos < (#lastpos+1)/2) => {
				local(i,o,ipos,opos)
				#ipos = #pos+#invpos
				#opos = #pos+(#lastpos-#invpos)
				#i = #str->get(#ipos)
				#o = #str->get(#opos)
				
				//'switching '+#i+' and '+#o+'\r'
				
				//'insert '+#o+' at '+(#ipos)+'\r'
				#str = string_insert(#str,-position=(#ipos),-text=#o)
	
				//'remove redundant pos '+(#ipos+1)+'\r'
				#str->remove(#ipos+1,1)
				
				//'insert '+#i+' at '+(#opos)+'\r'
				#str = string_insert(#str,-position=(#opos),-text=#i)
	
				//'remove redundant pos '+(#opos+1)+'\r'
				#str->remove(#opos+1,1)
				
				#invpos++
			}
			#pos += #lastpos - 1
		}
		//#str->get(#pos) + #isodd + '\r'
		#pos += 1
	}
	return #str
}

'orig:\rwhat,is,the;meaning,of:life.\r'
'new:\r'
odd_word_processor('what,is,the;meaning,of:life.')
'\rShould have:\rwhat,si,the;gninaem,of:efil.'
