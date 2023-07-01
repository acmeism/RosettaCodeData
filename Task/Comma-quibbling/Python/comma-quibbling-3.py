>>> def quibble(s):
    return ('{' +
                (', '.join(s[:-1]) + ' and ' if len(s) > 1 else '') +
	        (s[-1] if s else '') +
	    '}')

>>> for seq in ([], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"]):
	print('Input: %-24r -> Output: %r' % (seq, quibble(seq)))

	
Input: []                       -> Output: '{}'
Input: ['ABC']                  -> Output: '{ABC}'
Input: ['ABC', 'DEF']           -> Output: '{ABC and DEF}'
Input: ['ABC', 'DEF', 'G', 'H'] -> Output: '{ABC, DEF, G and H}'
>>>
