>>> def strcat(sequence):
    return '{%s}' % ', '.join(sequence)[::-1].replace(',', 'dna ', 1)[::-1]

>>> for seq in ([], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"]):
    print('Input: %-24r -> Output: %r' % (seq, strcat(seq)))

	
Input: []                       -> Output: '{}'
Input: ['ABC']                  -> Output: '{ABC}'
Input: ['ABC', 'DEF']           -> Output: '{ABC and DEF}'
Input: ['ABC', 'DEF', 'G', 'H'] -> Output: '{ABC, DEF, G and H}'
>>>
