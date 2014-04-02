def stripped(x):
	return "".join([i for i in x if 31 < ord(i) < 127])

print stripped("\ba\x00b\n\rc\fd\xc3")
