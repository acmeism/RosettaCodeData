def stripped(x):
	return "".join([i for i in x if ord(i) in range(32, 127)])

print stripped("\ba\x00b\n\rc\fd\xc3")
