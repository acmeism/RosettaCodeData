def do_stuff(a, b):
	return a + b

t = input()
for x in range(0, t):
	a, b = raw_input().strip().split()
	print do_stuff(int(a), int(b))
