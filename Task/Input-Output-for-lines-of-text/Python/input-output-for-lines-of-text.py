try: input = raw_input
except: pass

def do_stuff(words):
	print(words)

linecount = int(input())
for x in range(linecount):
	line = input()
	do_stuff(line)
