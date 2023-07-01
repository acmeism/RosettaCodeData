import random

class WumpusGame(object):


	def __init__(self, edges=[]):
		
		# Create arbitrary caves from a list of edges (see the end of the script for example).
		if edges:
			cave = {}
			N = max([edges[i][0] for i in range(len(edges))])
			for i in range(N):
				exits = [edge[1] for edge in edges if edge[0] == i]
				cave[i] = exits

		# If no edges are specified, play in the standard cave: a dodecahedron.
		else:
			cave = {1: [2,3,4], 2: [1,5,6], 3: [1,7,8], 4: [1,9,10], 5:[2,9,11],
				6: [2,7,12], 7: [3,6,13], 8: [3,10,14], 9: [4,5,15], 10: [4,8,16],
				11: [5,12,17], 12: [6,11,18], 13: [7,14,18], 14: [8,13,19],
				15: [9,16,17], 16: [10,15,19], 17: [11,20,15], 18: [12,13,20],
				19: [14,16,20], 20: [17,18,19]}

		self.cave = cave

		self.threats = {}

		self.arrows = 5

		self.arrow_travel_distance = 5		# As in the original game. I don't like this choice:
											# a bow should not cover a whole cave.
		self.player_pos = -1


	"""
	HELPER: These methods wrap processes that are useful or called often.
	"""


	def get_safe_rooms(self):
		""" Returns a list containing all numbers of rooms that
			do not contain any threats
		"""
		return list(set(self.cave.keys()).difference(self.threats.keys()))


	def populate_cave(self):
		""" Drop player and threats into random rooms in the cave.
		"""
		for threat in ['bat', 'bat', 'pit', 'pit', 'wumpus']:
			pos = random.choice(self.get_safe_rooms())
			self.threats[pos] = threat
		self.player_pos = random.choice(self.get_safe_rooms())


	def breadth_first_search(self, source, target, max_depth=5):
		""" The game board (whether custom or standard dodecahedron) is an undirected graph.
			The rooms are the vertices and the tunnels are the edges of this graph. To find
			out whether a target room can be reached from a source room using a given amount
			of tunnels, one can do a breadth first search on the underlying undirected graph.

			BFS works like this: start with the source vertex, maybe it is already the target?
			If not, then go a level deeper and find out, if one of the children (also called
			successors) of the source vertex is the wanted target. If not, then for each child,
			go a level deeper and find out if one of the grand-children is the wanted target.
			If not, then for each grand-child go a level deeper and so on.

			The following is a recursive implementation of BFS. You will not find any loops
			(for, while). Instead you manage two lists. The first one ('stack') contains all
			the vertices of the current depth-level (e.g. all grand children). The second
			('visited') contains all vertices that you already checked. Now there are three
			possibilites: Either stack is empty, then all vertices have been checked unsuccessfully;
			or the target vertex is a member of the stack, then you are happy; or the target is
			not a member of the stack, but there are still some vertices that you did not visit,
			then you append to the stack, all successors of the members of the stack and the old
			stack now belongs to the visited vertices.
		"""
		# Set up some initial values.
		graph = self.cave
		depth = 0

		def search(stack, visited, target, depth):
			if stack == []:					# The whole graph was searched, but target was not found.
				return False, -1
			if target in stack:
				return True, depth
			visited = visited + stack
			stack = list(set([graph[v][i] for v in stack for i in range(len(graph[v]))]).difference(visited))
			depth += 1
			if depth > max_depth:			# Target is too far away from the source.
				return False, depth
			else:							# Visit all successors of vertices in the stack.
				return search(stack, visited, target, depth)

		return search([source], [], target, depth)


	"""
	INPUT / OUTPUT: The player interacts with the game.
	"""


	def print_warning(self, threat):
		""" Called when entering a new room. Shows threats in adjacent rooms.
		"""
		if threat == 'bat':
			print("You hear a rustling.")
		elif threat == 'pit':
			print("You feel a cold wind blowing from a nearby cavern.")
		elif threat == 'wumpus':
			print("You smell something terrible nearby.")


	def get_players_input(self):
		""" Queries input until valid input is given.
		"""
		while 1:								# Query the action.

			inpt = input("Shoot or move (S-M)? ")
			try:								# Ensure that the player choses a valid action (shoot or move)
				mode = str(inpt).lower()
				assert mode in ['s', 'm', 'q']
				break
			except (ValueError, AssertionError):
				print("This is not a valid action: pick 'S' to shoot and 'M' to move.")

		if mode == 'q':							# I added a 'quit-button' for convenience.
			return 'q', 0

		while 1:								# Query the target of the action.

			inpt = input("Where to? ")
			try:								# Ensure that the chosen target is convertable to an integer.
				target = int(inpt)
			except ValueError:
				print("This is not even a real number.")
				continue						# Restart the while loop, to get a valid integer as target.

			if mode == 'm':
				try:							# When walking, the target must be adjacent to the current room.
					assert target in self.cave[self.player_pos]
					break
				except AssertionError:
					print("You cannot walk that far. Please use one of the tunnels.")

			elif mode == 's':
				try:							# When shooting, the target must be reachable within 5 tunnels.
					bfs = self.breadth_first_search(self.player_pos, target)
					assert bfs[0] == True
					break
				except AssertionError:
					if bfs[1] == -1: 			# The target is outside cave.
						print("There is no room with this number in the cave. Your arrow travels randomly.")
						target = random.choice(self.cave.keys())
					if bfs[1] > self.arrow_travel_distance:				# The target is too far.
						print("Arrows aren't that croocked.")

		return mode, target


	"""
	CORE / GAME LOGIC
	"""


	def enter_room(self, room_number):
		""" Controls the process of entering a new room.
		"""	
		print("Entering room {}...".format(room_number))
		# Maybe a threat waits in the new room.	
		if self.threats.get(room_number) == 'bat':
			# The bat teleports the player to random empty room
			print("You encounter a bat, it transports you to a random empty room.")
			new_pos = random.choice(self.get_safe_rooms())
			return self.enter_room(new_pos)
		elif self.threats.get(room_number) == 'wumpus':
			print("Wumpus eats you.")
			return -1
		elif self.threats.get(room_number) == 'pit':
			print("You fall into a pit.")
			return -1

		# The room is safe; collect information about adjacent rooms.
		for i in self.cave[room_number]:
			self.print_warning(self.threats.get(i))

		# Only if nothing else happens, the player enters the room of his choice.
		return room_number


	def shoot_room(self, room_number):
		""" Controls the process of shooting in a room.
		"""
		print("Shooting an arrow into room {}...".format(room_number))
		# Fire an arrow and see if something is hit by it.
		self.arrows -= 1
		threat = self.threats.get(room_number)
		if threat in ['bat', 'wumpus']:
			del self.threats[room_number]		
			if threat == 'wumpus':
				print("Hurra, you killed the wumpus!")
				return -1
			elif threat == 'bat':
				print("You killed a bat.")
		elif threat in ['pit', None]:
			print("This arrow is lost.")
		
		# If this was your last arrow and it did not hit the wumpus...
		if self.arrows < 1:		# This (or the updating of self.arrows) seems to be broken...
			print("Your quiver is empty.")
			return -1

		#  If you shoot into another room, the Wumpus has a 75% of chance of waking up and moving into an adjacent room.
		if random.random() < 0.75:
			#print("DEBUG: Wumpus moved.")
			for room_number, threat in self.threats.items():
				if threat == 'wumpus':
					wumpus_pos = room_number					
			new_pos = random.choice(list(set(self.cave[wumpus_pos]).difference(self.threats.keys())))
			del self.threats[room_number]
			self.threats[new_pos] = 'wumpus'			
			if new_pos == self.player_pos: # Wumpus entered players room.
				print("Wumpus enters your room and eats you!")
				return -1

		return self.player_pos

		
	def gameloop(self):

		print("HUNT THE WUMPUS")
		print("===============")
		print()
		self.populate_cave()
		self.enter_room(self.player_pos)

		while 1:

			#print("DEBUG: Your quiver holds {} arrows.".format(self.arrows))			
			#print("DEBUG: Rooms with no threats are: {}.".format(self.get_safe_rooms()))			
			#print("DEBUG: Threats are located in the following rooms: {}".format(self.threats))

			print("You are in room {}.".format(self.player_pos), end=" ")
			print("Tunnels lead to:  {0}  {1}  {2}".format(*self.cave[self.player_pos]))
			
			
			inpt = self.get_players_input()		# Player choses move or shoot.
			print()								# Visual separation of rounds.
			if inpt[0] == 'm':					# Move.
				target = inpt[1]
				self.player_pos = self.enter_room(target)
			elif inpt[0] == 's':				# Shoot.
				target = inpt[1]
				self.player_pos = self.shoot_room(target)
			elif inpt[0] == 'q':				# Quit.
				self.player_pos = -1

			if self.player_pos == -1:			# E.g. Deadly threat, quiver empty, etc.
				break							# If any of the game loosing conditions are True,
												# then player_pos will be -1.

		print()
		print("Game over!")	
		

if __name__ == '__main__':						
	# Only executed if you start this script as the main script,
	# i.e. you enter 'python path/to/wumpus.py' in a terminal.
	# Assuming you saved the script in the directory 'path/to'
	# and named it 'wumpus.py'.

	# TODO: In the original game you can replay a dungeon (same positions of you and the threats)

	WG = WumpusGame()
	WG.gameloop()
