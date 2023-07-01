def merge_list(a, b):
	out = []
	while len(a) and len(b):
		if a[0] < b[0]:
			out.append(a.pop(0))
		else:
			out.append(b.pop(0))
	out += a
	out += b
	return out

def strand(a):
	i, s = 0, [a.pop(0)]
	while i < len(a):
		if a[i] > s[-1]:
			s.append(a.pop(i))
		else:
			i += 1
	return s

def strand_sort(a):
	out = strand(a)
	while len(a):
		out = merge_list(out, strand(a))
	return out

print strand_sort([1, 6, 3, 2, 1, 7, 5, 3])
