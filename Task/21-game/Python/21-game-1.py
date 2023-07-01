from random import randint
def start():
	game_count=0
	print("Enter q to quit at any time.\nThe computer will choose first.\nRunning total is now {}".format(game_count))
	roundno=1
	while game_count<21:
		print("\nROUND {}: \n".format(roundno))
		t = select_count(game_count)
		game_count = game_count+t
		print("Running total is now {}\n".format(game_count))
		if game_count>=21:
			print("So, commiserations, the computer has won!")
			return 0
		t = request_count()
		if not t:
			print('OK,quitting the game')
			return -1
		game_count = game_count+t
		print("Running total is now {}\n".format(game_count))
		if game_count>=21:
			print("So, congratulations, you've won!")
			return 1
		roundno+=1

def select_count(game_count):
	'''selects a random number if the game_count is less than 18. otherwise chooses the winning number'''
	if game_count<18:
		t= randint(1,3)
	else:
		t = 21-game_count
	print("The computer chooses {}".format(t))
	return t

def request_count():
	'''request user input between 1,2 and 3. It will continue till either quit(q) or one of those numbers is requested.'''
	t=""
	while True:
		try:
			t = raw_input('Your choice 1 to 3 :')
			if int(t) in [1,2,3]:
				return int(t)
			else:
				print("Out of range, try again")
		except:
			if t=="q":
				return None
			else:
				print("Invalid Entry, try again")

c=0
m=0
r=True
while r:
	o = start()
	if o==-1:
		break
	else:
		c+=1 if o==0 else 0
		m+=1 if o==1 else 0
	print("Computer wins {0} game, human wins {1} games".format(c,m))
	t = raw_input("Another game?(press y to continue):")
	r = (t=="y")
