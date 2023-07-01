from os import system, name
from time import sleep

def clear():
	if name == 'nt':
		_ = system('cls')
	else: _ = system('clear')

def exit():
	import sys
	clear()
	sys.exit()

def make_area(x, y):
	area = [[0]*x for _ in range(y)]
	return area

def make_sandpile(area, loc, height):
	loc=list(n-1 for n in loc)
	x, y = loc

	try: area[y][x]+=height
	except IndexError: pass
	
def run(area, by_frame=False):
	def run_frame():
		for y_index, group in enumerate(area):
			y = y_index+1

			for x_index, height in enumerate(group):
				x = x_index+1

				if height < 4: continue

				else:
					make_sandpile(area, (x+1, y), 1)
					make_sandpile(area, (x, y+1), 1)

					if x_index-1 >= 0:
						make_sandpile(area, (x-1, y), 1)
					if y_index-1 >= 0:
						make_sandpile(area, (x, y-1), 1)

					make_sandpile(area, (x, y), -4)

	while any([any([pile>=4 for pile in group]) for group in area]):
		if by_frame:
			clear()
		run_frame()
		if by_frame:
			show_area(area); sleep(.05)

def show_area(area):
	display = [' '.join([str(item) if item else ' ' for item in group])
			   for group in area]
	[print(i) for i in display]

clear()
if __name__ == '__main__':
	area = make_area(10, 10)
	print('\nBefore:')
	show_area(area)
	make_sandpile(area, (5, 5), 64)
	run(area)
	print('\nAfter:')
	show_area(area)
