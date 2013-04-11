>>> def bin2gray(bits):
	return bits[:1] + [i ^ ishift for i, ishift in zip(bits[:-1], bits[1:])]

>>> def gray2bin(bits):
	b = [bits[0]]
	for nextb in bits[1:]: b.append(b[-1] ^ nextb)
	return b
