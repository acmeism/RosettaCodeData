add_plink=: [:;{{ <y,"1 0 x #~ 1 p:+/|:(x=. x-. y),"0/{: y }}"1
prime_pair_seqs=: {{ y add_plink (2}.i.y) add_plink^:(y-2) 1 }}
