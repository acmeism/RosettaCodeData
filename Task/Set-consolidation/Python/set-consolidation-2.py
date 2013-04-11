def conso(s):
	if len(s) < 2: return s

	r, b = [s[0]], conso(s[1:])
	for x in b:
		if r[0].intersection(x): r[0].update(x)
		else: r.append(x)
	return r
