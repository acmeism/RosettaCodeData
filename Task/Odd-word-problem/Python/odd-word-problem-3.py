from sys import stdin, stdout

def char_in(): return stdin.read(1)
def char_out(c): stdout.write(c)

def odd():
	a = char_in()
	if a.isalpha():
		r = odd()
		char_out(a)
		return r

	# delay printing terminator until later, in the shape of a closure
	def clos():
		char_out(a)
		return a != '.'

	return clos

def even():
	while True:
		c = char_in()
		char_out(c)
		if not c.isalpha(): return c != '.'

e = False
while odd()() if e else even():
	e = not e
