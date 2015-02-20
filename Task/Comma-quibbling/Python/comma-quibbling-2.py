def commaQuibble(s):
    return '{%s}' % ' and '.join(s).replace(' and ', ', ', len(s) - 2)

for seq in ([], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"]):
	print('Input: %-24r -> Output: %r' % (seq, commaQuibble(seq)))
