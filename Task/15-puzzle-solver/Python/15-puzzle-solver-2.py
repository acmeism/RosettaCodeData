"""

Python example for this Rosetta Code task:

http://rosettacode.org/wiki/15_puzzle_solver

Using A* Algorithm from Wikkipedia:

https://en.wikipedia.org/wiki/A*_search_algorithm

Need to use heuristic that guarantees a shortest path
solution.

"""

import heapq
import copy

# Hopefully this is larger than any fscore or gscore

integer_infinity = 1000000000

class Position(object):
    """Position class represents one position of a 15 puzzle"""

    def __init__(self, tiles):
        """
        Takes a tuple of tuples representing the tiles on a 4x4 puzzle board
        numbering 1-15 with 0 representing an empty square. For example:

        (( 1,  2,  3,  4),
         ( 5,  6,  7,  8),
         ( 9, 10, 11, 12),
         (13, 14, 15,  0))

        Converts list of lists representation into tuple of tuples.
        """
        if type(tiles) == type(list()):
            t = tiles
            self.tiles = ((t[0][0], t[0][1], t[0][2], t[0][3]),
                          (t[1][0], t[1][1], t[1][2], t[1][3]),
                          (t[2][0], t[2][1], t[2][2], t[2][3]),
                          (t[3][0], t[3][1], t[3][2], t[3][3]))
        else:
            self.tiles = tiles

        # fields for A* algorithm

        self.fscore = integer_infinity
        self.gscore = integer_infinity

        self.cameFrom = None

    def copy_tiles(self):
        """ returns list of lists version """
        t = self.tiles

        return [[t[0][0], t[0][1], t[0][2], t[0][3]],
                [t[1][0], t[1][1], t[1][2], t[1][3]],
                [t[2][0], t[2][1], t[2][2], t[2][3]],
                [t[3][0], t[3][1], t[3][2], t[3][3]]]


    def neighbors(self):
        """
        returns a list of neighbors
        returns a list position objects with their
        directiontomoveto set to the direction that the
        empty square moved.

        tiles is 4x4 tuple of tuples with
        0,0 as top left.

        tiles[y][x]

        """

        # find 0 - blank square

        x0 = None
        y0 = None

        for i in range(4):
            for j in range(4):
                if self.tiles[i][j] == 0:
                    y0 = i
                    x0 = j

        if x0 == None or y0 == None:
            return []

        neighbor_list = []

        # move 0 to the right
        if x0 < 3:
            new_tiles = self.copy_tiles()
            temp = new_tiles[y0][x0+1]
            new_tiles[y0][x0+1] = 0
            new_tiles[y0][x0] = temp
            new_pos = new_position(new_tiles)
            neighbor_list.append(new_pos)
        # move 0 to the left
        if x0 > 0:
            new_tiles = self.copy_tiles()
            temp = new_tiles[y0][x0-1]
            new_tiles[y0][x0-1] = 0
            new_tiles[y0][x0] = temp
            new_pos = new_position(new_tiles)
            neighbor_list.append(new_pos)
        # move 0 up
        if y0 > 0:
            new_tiles = self.copy_tiles()
            temp = new_tiles[y0-1][x0]
            new_tiles[y0-1][x0] = 0
            new_tiles[y0][x0] = temp
            new_pos = new_position(new_tiles)
            neighbor_list.append(new_pos)
        # move 0 down
        if y0 < 3:
            new_tiles = self.copy_tiles()
            temp = new_tiles[y0+1][x0]
            new_tiles[y0+1][x0] = 0
            new_tiles[y0][x0] = temp
            new_pos = new_position(new_tiles)
            neighbor_list.append(new_pos)

        return neighbor_list

    def __repr__(self):
        # printable version of self

        return str(self.tiles[0])+'\n'+str(self.tiles[1])+'\n'+str(self.tiles[2])+'\n'+str(self.tiles[3])+'\n'

# takes tuple of tuples tiles as key, Position object for that tiles as value

all_positions = dict()

def new_position(tiles):
    """ returns a new position or looks up existing one """
    global all_positions
    if type(tiles) == type(list()):
        t = tiles
        tuptiles =   ((t[0][0], t[0][1], t[0][2], t[0][3]),
                      (t[1][0], t[1][1], t[1][2], t[1][3]),
                      (t[2][0], t[2][1], t[2][2], t[2][3]),
                      (t[3][0], t[3][1], t[3][2], t[3][3]))
    else:
        tuptiles = tiles

    if tuptiles in all_positions:
        return 	all_positions[tuptiles]
    else:
        new_pos = Position(tiles)
        all_positions[tuptiles] = new_pos
        return new_pos

def reconstruct_path(current):
    """
    Uses the cameFrom members to follow the chain of moves backwards
    and then reverses the list to get the path in the correct order.
    """
    total_path = [current]

    while current.cameFrom != None:
        current = current.cameFrom
        total_path.append(current)

    total_path.reverse()

    return total_path

class PriorityQueue(object):
    """
    Priority queue using heapq.
    elements of queue are (fscore,tiles) for each position.
    If element is removed from queue and fscore doesn't match
    then that element is discarded.
    """

    def __init__(self, object_list):
        """
        Save a list in a heapq.
        Assume that each object only appears once
        in the list.
        """
        self.queue_length = 0
        self.qheap = []
        for e in object_list:
            self.qheap.append((e.fscore,e.tiles))
            self.queue_length += 1
        heapq.heapify(self.qheap)

    def push(self, new_object):
        """ save object in heapq """
        heapq.heappush(self.qheap,(new_object.fscore,new_object.tiles))
        self.queue_length += 1

    def pop(self):
        """ remove object from heap and return """
        if self.queue_length < 1:
            return None
        fscore, tiles = heapq.heappop(self.qheap)
        self.queue_length -= 1
        global all_positions
        pos = all_positions[tiles]
        if pos.fscore == fscore:
            return pos
        else:
            return self.pop()

    def __repr__(self):
        # printable version of self
        strrep = ""
        for e in self.qheap:
          fscore, tiles = e
          strrep += str(fscore)+":"+str(tiles)+"\n"

        return strrep

conflict_table = None

def build_conflict_table():
    global conflict_table
    conflict_table = dict()

    # assumes goal tuple has up to
    # for the given pattern it the start position
    # how much to add for linear conflicts
    # 2 per conflict - max of 6

    # goal tuple is ('g0', 'g1', 'g2', 'g3')

    conflict_table[('g0', 'g1', 'g2', 'g3')] = 0
    conflict_table[('g0', 'g1', 'g2', 'x')] = 0
    conflict_table[('g0', 'g1', 'g3', 'g2')] = 2
    conflict_table[('g0', 'g1', 'g3', 'x')] = 0
    conflict_table[('g0', 'g1', 'x', 'g2')] = 0
    conflict_table[('g0', 'g1', 'x', 'g3')] = 0
    conflict_table[('g0', 'g1', 'x', 'x')] = 0
    conflict_table[('g0', 'g2', 'g1', 'g3')] = 2
    conflict_table[('g0', 'g2', 'g1', 'x')] = 2
    conflict_table[('g0', 'g2', 'g3', 'g1')] = 4
    conflict_table[('g0', 'g2', 'g3', 'x')] = 0
    conflict_table[('g0', 'g2', 'x', 'g1')] = 2
    conflict_table[('g0', 'g2', 'x', 'g3')] = 0
    conflict_table[('g0', 'g2', 'x', 'x')] = 0
    conflict_table[('g0', 'g3', 'g1', 'g2')] = 4
    conflict_table[('g0', 'g3', 'g1', 'x')] = 2
    conflict_table[('g0', 'g3', 'g2', 'g1')] = 4
    conflict_table[('g0', 'g3', 'g2', 'x')] = 2
    conflict_table[('g0', 'g3', 'x', 'g1')] = 2
    conflict_table[('g0', 'g3', 'x', 'g2')] = 2
    conflict_table[('g0', 'g3', 'x', 'x')] = 0
    conflict_table[('g0', 'x', 'g1', 'g2')] = 0
    conflict_table[('g0', 'x', 'g1', 'g3')] = 0
    conflict_table[('g0', 'x', 'g1', 'x')] = 0
    conflict_table[('g0', 'x', 'g2', 'g1')] = 2
    conflict_table[('g0', 'x', 'g2', 'g3')] = 0
    conflict_table[('g0', 'x', 'g2', 'x')] = 0
    conflict_table[('g0', 'x', 'g3', 'g1')] = 2
    conflict_table[('g0', 'x', 'g3', 'g2')] = 2
    conflict_table[('g0', 'x', 'g3', 'x')] = 0
    conflict_table[('g0', 'x', 'x', 'g1')] = 0
    conflict_table[('g0', 'x', 'x', 'g2')] = 0
    conflict_table[('g0', 'x', 'x', 'g3')] = 0
    conflict_table[('g1', 'g0', 'g2', 'g3')] = 2
    conflict_table[('g1', 'g0', 'g2', 'x')] = 2
    conflict_table[('g1', 'g0', 'g3', 'g2')] = 4
    conflict_table[('g1', 'g0', 'g3', 'x')] = 2
    conflict_table[('g1', 'g0', 'x', 'g2')] = 2
    conflict_table[('g1', 'g0', 'x', 'g3')] = 2
    conflict_table[('g1', 'g0', 'x', 'x')] = 2
    conflict_table[('g1', 'g2', 'g0', 'g3')] = 4
    conflict_table[('g1', 'g2', 'g0', 'x')] = 4
    conflict_table[('g1', 'g2', 'g3', 'g0')] = 6
    conflict_table[('g1', 'g2', 'g3', 'x')] = 0
    conflict_table[('g1', 'g2', 'x', 'g0')] = 4
    conflict_table[('g1', 'g2', 'x', 'g3')] = 0
    conflict_table[('g1', 'g2', 'x', 'x')] = 0
    conflict_table[('g1', 'g3', 'g0', 'g2')] = 4
    conflict_table[('g1', 'g3', 'g0', 'x')] = 4
    conflict_table[('g1', 'g3', 'g2', 'g0')] = 6
    conflict_table[('g1', 'g3', 'g2', 'x')] = 0
    conflict_table[('g1', 'g3', 'x', 'g0')] = 4
    conflict_table[('g1', 'g3', 'x', 'g2')] = 2
    conflict_table[('g1', 'g3', 'x', 'x')] = 0
    conflict_table[('g1', 'x', 'g0', 'g2')] = 2
    conflict_table[('g1', 'x', 'g0', 'g3')] = 2
    conflict_table[('g1', 'x', 'g0', 'x')] = 2
    conflict_table[('g1', 'x', 'g2', 'g0')] = 4
    conflict_table[('g1', 'x', 'g2', 'g3')] = 0
    conflict_table[('g1', 'x', 'g2', 'x')] = 0
    conflict_table[('g1', 'x', 'g3', 'g0')] = 4
    conflict_table[('g1', 'x', 'g3', 'g2')] = 2
    conflict_table[('g1', 'x', 'g3', 'x')] = 0
    conflict_table[('g1', 'x', 'x', 'g0')] = 2
    conflict_table[('g1', 'x', 'x', 'g2')] = 0
    conflict_table[('g1', 'x', 'x', 'g3')] = 0
    conflict_table[('g2', 'g0', 'g1', 'g3')] = 4
    conflict_table[('g2', 'g0', 'g1', 'x')] = 4
    conflict_table[('g2', 'g0', 'g3', 'g1')] = 4
    conflict_table[('g2', 'g0', 'g3', 'x')] = 2
    conflict_table[('g2', 'g0', 'x', 'g1')] = 4
    conflict_table[('g2', 'g0', 'x', 'g3')] = 2
    conflict_table[('g2', 'g0', 'x', 'x')] = 2
    conflict_table[('g2', 'g1', 'g0', 'g3')] = 4
    conflict_table[('g2', 'g1', 'g0', 'x')] = 4
    conflict_table[('g2', 'g1', 'g3', 'g0')] = 6
    conflict_table[('g2', 'g1', 'g3', 'x')] = 2
    conflict_table[('g2', 'g1', 'x', 'g0')] = 4
    conflict_table[('g2', 'g1', 'x', 'g3')] = 2
    conflict_table[('g2', 'g1', 'x', 'x')] = 2
    conflict_table[('g2', 'g3', 'g0', 'g1')] = 4
    conflict_table[('g2', 'g3', 'g0', 'x')] = 4
    conflict_table[('g2', 'g3', 'g1', 'g0')] = 6
    conflict_table[('g2', 'g3', 'g1', 'x')] = 4
    conflict_table[('g2', 'g3', 'x', 'g0')] = 4
    conflict_table[('g2', 'g3', 'x', 'g1')] = 4
    conflict_table[('g2', 'g3', 'x', 'x')] = 0
    conflict_table[('g2', 'x', 'g0', 'g1')] = 4
    conflict_table[('g2', 'x', 'g0', 'g3')] = 2
    conflict_table[('g2', 'x', 'g0', 'x')] = 2
    conflict_table[('g2', 'x', 'g1', 'g0')] = 4
    conflict_table[('g2', 'x', 'g1', 'g3')] = 2
    conflict_table[('g2', 'x', 'g1', 'x')] = 2
    conflict_table[('g2', 'x', 'g3', 'g0')] = 4
    conflict_table[('g2', 'x', 'g3', 'g1')] = 4
    conflict_table[('g2', 'x', 'g3', 'x')] = 0
    conflict_table[('g2', 'x', 'x', 'g0')] = 2
    conflict_table[('g2', 'x', 'x', 'g1')] = 2
    conflict_table[('g2', 'x', 'x', 'g3')] = 0
    conflict_table[('g3', 'g0', 'g1', 'g2')] = 6
    conflict_table[('g3', 'g0', 'g1', 'x')] = 4
    conflict_table[('g3', 'g0', 'g2', 'g1')] = 6
    conflict_table[('g3', 'g0', 'g2', 'x')] = 4
    conflict_table[('g3', 'g0', 'x', 'g1')] = 4
    conflict_table[('g3', 'g0', 'x', 'g2')] = 4
    conflict_table[('g3', 'g0', 'x', 'x')] = 2
    conflict_table[('g3', 'g1', 'g0', 'g2')] = 6
    conflict_table[('g3', 'g1', 'g0', 'x')] = 4
    conflict_table[('g3', 'g1', 'g2', 'g0')] = 6
    conflict_table[('g3', 'g1', 'g2', 'x')] = 4
    conflict_table[('g3', 'g1', 'x', 'g0')] = 4
    conflict_table[('g3', 'g1', 'x', 'g2')] = 4
    conflict_table[('g3', 'g1', 'x', 'x')] = 2
    conflict_table[('g3', 'g2', 'g0', 'g1')] = 6
    conflict_table[('g3', 'g2', 'g0', 'x')] = 4
    conflict_table[('g3', 'g2', 'g1', 'g0')] = 6
    conflict_table[('g3', 'g2', 'g1', 'x')] = 4
    conflict_table[('g3', 'g2', 'x', 'g0')] = 4
    conflict_table[('g3', 'g2', 'x', 'g1')] = 4
    conflict_table[('g3', 'g2', 'x', 'x')] = 2
    conflict_table[('g3', 'x', 'g0', 'g1')] = 4
    conflict_table[('g3', 'x', 'g0', 'g2')] = 4
    conflict_table[('g3', 'x', 'g0', 'x')] = 2
    conflict_table[('g3', 'x', 'g1', 'g0')] = 4
    conflict_table[('g3', 'x', 'g1', 'g2')] = 4
    conflict_table[('g3', 'x', 'g1', 'x')] = 2
    conflict_table[('g3', 'x', 'g2', 'g0')] = 4
    conflict_table[('g3', 'x', 'g2', 'g1')] = 4
    conflict_table[('g3', 'x', 'g2', 'x')] = 2
    conflict_table[('g3', 'x', 'x', 'g0')] = 2
    conflict_table[('g3', 'x', 'x', 'g1')] = 2
    conflict_table[('g3', 'x', 'x', 'g2')] = 2
    conflict_table[('x', 'g0', 'g1', 'g2')] = 0
    conflict_table[('x', 'g0', 'g1', 'g3')] = 0
    conflict_table[('x', 'g0', 'g1', 'x')] = 0
    conflict_table[('x', 'g0', 'g2', 'g1')] = 2
    conflict_table[('x', 'g0', 'g2', 'g3')] = 0
    conflict_table[('x', 'g0', 'g2', 'x')] = 0
    conflict_table[('x', 'g0', 'g3', 'g1')] = 2
    conflict_table[('x', 'g0', 'g3', 'g2')] = 2
    conflict_table[('x', 'g0', 'g3', 'x')] = 0
    conflict_table[('x', 'g0', 'x', 'g1')] = 0
    conflict_table[('x', 'g0', 'x', 'g2')] = 0
    conflict_table[('x', 'g0', 'x', 'g3')] = 0
    conflict_table[('x', 'g1', 'g0', 'g2')] = 2
    conflict_table[('x', 'g1', 'g0', 'g3')] = 2
    conflict_table[('x', 'g1', 'g0', 'x')] = 2
    conflict_table[('x', 'g1', 'g2', 'g0')] = 4
    conflict_table[('x', 'g1', 'g2', 'g3')] = 0
    conflict_table[('x', 'g1', 'g2', 'x')] = 0
    conflict_table[('x', 'g1', 'g3', 'g0')] = 4
    conflict_table[('x', 'g1', 'g3', 'g2')] = 2
    conflict_table[('x', 'g1', 'g3', 'x')] = 0
    conflict_table[('x', 'g1', 'x', 'g0')] = 2
    conflict_table[('x', 'g1', 'x', 'g2')] = 0
    conflict_table[('x', 'g1', 'x', 'g3')] = 0
    conflict_table[('x', 'g2', 'g0', 'g1')] = 4
    conflict_table[('x', 'g2', 'g0', 'g3')] = 2
    conflict_table[('x', 'g2', 'g0', 'x')] = 2
    conflict_table[('x', 'g2', 'g1', 'g0')] = 4
    conflict_table[('x', 'g2', 'g1', 'g3')] = 2
    conflict_table[('x', 'g2', 'g1', 'x')] = 2
    conflict_table[('x', 'g2', 'g3', 'g0')] = 4
    conflict_table[('x', 'g2', 'g3', 'g1')] = 4
    conflict_table[('x', 'g2', 'g3', 'x')] = 0
    conflict_table[('x', 'g2', 'x', 'g0')] = 2
    conflict_table[('x', 'g2', 'x', 'g1')] = 2
    conflict_table[('x', 'g2', 'x', 'g3')] = 0
    conflict_table[('x', 'g3', 'g0', 'g1')] = 4
    conflict_table[('x', 'g3', 'g0', 'g2')] = 4
    conflict_table[('x', 'g3', 'g0', 'x')] = 2
    conflict_table[('x', 'g3', 'g1', 'g0')] = 4
    conflict_table[('x', 'g3', 'g1', 'g2')] = 4
    conflict_table[('x', 'g3', 'g1', 'x')] = 2
    conflict_table[('x', 'g3', 'g2', 'g0')] = 4
    conflict_table[('x', 'g3', 'g2', 'g1')] = 4
    conflict_table[('x', 'g3', 'g2', 'x')] = 2
    conflict_table[('x', 'g3', 'x', 'g0')] = 2
    conflict_table[('x', 'g3', 'x', 'g1')] = 2
    conflict_table[('x', 'g3', 'x', 'g2')] = 2
    conflict_table[('x', 'x', 'g0', 'g1')] = 0
    conflict_table[('x', 'x', 'g0', 'g2')] = 0
    conflict_table[('x', 'x', 'g0', 'g3')] = 0
    conflict_table[('x', 'x', 'g1', 'g0')] = 2
    conflict_table[('x', 'x', 'g1', 'g2')] = 0
    conflict_table[('x', 'x', 'g1', 'g3')] = 0
    conflict_table[('x', 'x', 'g2', 'g0')] = 2
    conflict_table[('x', 'x', 'g2', 'g1')] = 2
    conflict_table[('x', 'x', 'g2', 'g3')] = 0
    conflict_table[('x', 'x', 'g3', 'g0')] = 2
    conflict_table[('x', 'x', 'g3', 'g1')] = 2
    conflict_table[('x', 'x', 'g3', 'g2')] = 2

def linear_conflicts(start_list,goal_list):
    """
    calculates number of moves to add to the estimate of
    the moves to get from start to goal based on the number
    of conflicts on a given row or column. start_list
    represents the current location and goal_list represnts
    the final goal.
    """

    # Find which of the tiles in start_list have their goals on this line
    # build a pattern to use in a lookup table of this form:
    # g0, g1, g3, g3 fill in x where there is no goal for this line

    # all 'x' until we file a tile whose goal is in this line

    goal_pattern = ['x', 'x', 'x', 'x']

    for g in range(4):
        for s in range(4):
            start_tile_num = start_list[s]
            if start_tile_num == goal_list[g] and start_tile_num != 0:
                goal_pattern[s] = 'g' + str(g) # i.e. g0

    global conflict_table

    tup_goal_pattern = tuple(goal_pattern)

    if tup_goal_pattern in conflict_table:
        return conflict_table[tuple(goal_pattern)]
    else:
        return 0

class lcmap(dict):
    """
    Lets you return 0 if you look for an object that
    is not in the dictionary.
    """
    def __missing__(self, key):
        return 0

def listconflicts(goal_list):
    """
    list all possible start lists that will have at least
    one linear conflict.

    Possible goal tile configurations

    g g g g
    g g g x
    g g x g
    g x g g
    x g g g
    g g x x
    g x g x
    g x x g
    x g g x
    x g x g
    x x g g

    """

    all_tiles = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

    non_goal_tiles = []

    for t in all_tiles:
        if t not in goal_list:
            non_goal_tiles.append(t)

    combinations = lcmap()

    # g g g g

    for i in goal_list:
        tile_list2 = goal_list[:]
        tile_list2.remove(i)
        for j in tile_list2:
            tile_list3 = tile_list2[:]
            tile_list3.remove(j)
            for k in tile_list3:
                tile_list4 = tile_list3[:]
                tile_list4.remove(k)
                for l in tile_list4:
                    start_list = (i, j, k, l)
                    conflictadd = linear_conflicts(start_list,goal_list)
                    if conflictadd > 0:
                        combinations[start_list]=conflictadd

    # g g g x

    for i in goal_list:
        tile_list2 = goal_list[:]
        tile_list2.remove(i)
        for j in tile_list2:
            tile_list3 = tile_list2[:]
            tile_list3.remove(j)
            for k in tile_list3:
                for l in non_goal_tiles:
                    start_list = (i, j, k, l)
                    conflictadd = linear_conflicts(start_list,goal_list)
                    if conflictadd > 0:
                        combinations[start_list]=conflictadd

    # g g x g

    for i in goal_list:
        tile_list2 = goal_list[:]
        tile_list2.remove(i)
        for j in tile_list2:
            tile_list3 = tile_list2[:]
            tile_list3.remove(j)
            for k in non_goal_tiles:
                for l in tile_list3:
                    start_list = (i, j, k, l)
                    conflictadd = linear_conflicts(start_list,goal_list)
                    if conflictadd > 0:
                        combinations[start_list]=conflictadd
    # g x g g

    for i in goal_list:
        tile_list2 = goal_list[:]
        tile_list2.remove(i)
        for j in non_goal_tiles:
            for k in tile_list2:
                tile_list3 = tile_list2[:]
                tile_list3.remove(k)
                for l in tile_list3:
                    start_list = (i, j, k, l)
                    conflictadd = linear_conflicts(start_list,goal_list)
                    if conflictadd > 0:
                        combinations[start_list]=conflictadd

    # x g g g

    for i in non_goal_tiles:
        for j in goal_list:
            tile_list2 = goal_list[:]
            tile_list2.remove(j)
            for k in tile_list2:
                tile_list3 = tile_list2[:]
                tile_list3.remove(k)
                for l in tile_list3:
                    start_list = (i, j, k, l)
                    conflictadd = linear_conflicts(start_list,goal_list)
                    if conflictadd > 0:
                        combinations[start_list]=conflictadd

    # g g x x

    for i in goal_list:
        tile_list2 = goal_list[:]
        tile_list2.remove(i)
        for j in tile_list2:
            tile_list3 = tile_list2[:]
            tile_list3.remove(j)
            for k in non_goal_tiles:
                tile_list4 = non_goal_tiles[:]
                tile_list4.remove(k)
                for l in tile_list4:
                    start_list = (i, j, k, l)
                    conflictadd = linear_conflicts(start_list,goal_list)
                    if conflictadd > 0:
                        combinations[start_list]=conflictadd

    # g x g x

    for i in goal_list:
        tile_list2 = goal_list[:]
        tile_list2.remove(i)
        for j in non_goal_tiles:
            tile_list3 = non_goal_tiles[:]
            tile_list3.remove(j)
            for k in tile_list2:
                for l in tile_list3:
                    start_list = (i, j, k, l)
                    conflictadd = linear_conflicts(start_list,goal_list)
                    if conflictadd > 0:
                        combinations[start_list]=conflictadd

    # g x x g

    for i in goal_list:
        tile_list2 = goal_list[:]
        tile_list2.remove(i)
        for j in non_goal_tiles:
            tile_list3 = non_goal_tiles[:]
            tile_list3.remove(j)
            for k in tile_list2:
                for l in tile_list3:
                    start_list = (i, j, k, l)
                    conflictadd = linear_conflicts(start_list,goal_list)
                    if conflictadd > 0:
                        combinations[start_list]=conflictadd

    # x g g x

    for i in non_goal_tiles:
        tile_list2 = non_goal_tiles[:]
        tile_list2.remove(i)
        for j in goal_list:
            tile_list3 = goal_list[:]
            tile_list3.remove(j)
            for k in tile_list3:
                for l in tile_list2:
                    start_list = (i, j, k, l)
                    conflictadd = linear_conflicts(start_list,goal_list)
                    if conflictadd > 0:
                        combinations[start_list]=conflictadd

    # x g x g

    for i in non_goal_tiles:
        tile_list2 = non_goal_tiles[:]
        tile_list2.remove(i)
        for j in goal_list:
            tile_list3 = goal_list[:]
            tile_list3.remove(j)
            for k in tile_list3:
                for l in tile_list2:
                    start_list = (i, j, k, l)
                    conflictadd = linear_conflicts(start_list,goal_list)
                    if conflictadd > 0:
                        combinations[start_list]=conflictadd

    # x x g g

    for i in non_goal_tiles:
        tile_list2 = non_goal_tiles[:]
        tile_list2.remove(i)
        for j in tile_list2:
            for k in goal_list:
                tile_list3 = goal_list[:]
                tile_list3.remove(k)
                for l in tile_list3:
                    start_list = (i, j, k, l)
                    conflictadd = linear_conflicts(start_list,goal_list)
                    if conflictadd > 0:
                        combinations[start_list]=conflictadd

    return combinations


class HeuristicObj(object):
    """ Object used to preprocess goal position for heuristic function """

    def __init__(self, goal):
        """
        Preprocess goal position to setup internal data structures
        that can be used to speed up heuristic.
        """

        build_conflict_table()

        self.goal_map = []
        for i in range(16):
            self.goal_map.append(i)

        self.goal_lists = goal.tiles

        # preprocess for manhattan distance

        for row in range(4):
            for col in range(4):
                self.goal_map[goal.tiles[row][col]] = (row, col)

        # make access faster by changing to a tuple

        self.goal_map = tuple(self.goal_map)

        # preprocess for linear conflicts

        self.row_conflicts = []
        for row in range(4):
            t = goal.tiles[row]
            conf_dict = listconflicts([t[0],t[1],t[2],t[3]])
            self.row_conflicts.append(conf_dict)

        self.col_conflicts = []
        for col in range(4):
            col_list =[]
            for row in range(4):
                col_list.append(goal.tiles[row][col])
            conf_dict = listconflicts(col_list)
            self.col_conflicts.append(conf_dict)

    def heuristic(self, start):
        """

        Estimates the number of moves from start to goal.
        The goal was preprocessed in __init__.

        """

        distance = 0

        # local variables for instance variables

        t = start.tiles
        g = self.goal_map
        rc = self.row_conflicts
        cc = self.col_conflicts

        # calculate manhattan distance

        for row in range(4):
            for col in range(4):
                start_tilenum = t[row][col]
                if start_tilenum != 0:
                    (grow, gcol) = g[start_tilenum]
                    distance += abs(row - grow) + abs(col - gcol)

        # add linear conflicts

        for row in range(4):
            curr_row = t[row]
            distance += rc[row][curr_row]

        for col in range(4):
            col_tuple = (t[0][col], t[1][col], t[2][col], t[3][col])
            distance += cc[col][col_tuple]

        return distance

# global variable for heuristic object

hob = None

def a_star(start_tiles, goal_tiles):
    """ Based on https://en.wikipedia.org/wiki/A*_search_algorithm """

    start = new_position(start_tiles)
    goal = new_position(goal_tiles)

    # Process goal position for use in heuristic

    global hob
    hob = HeuristicObj(goal)

    # The set of currently discovered nodes that are not evaluated yet.
    # Initially, only the start node is known.
    # For the first node, the fscore is completely heuristic.

    start.fscore = hob.heuristic(start)
    openSet = PriorityQueue([start])

    # The cost of going from start to start is zero.

    start.gscore = 0

    num_popped = 0

    while openSet.queue_length > 0:
        current = openSet.pop()
        if current == None: # tried to pop but only found old fscore values
            break
        num_popped += 1
        if num_popped % 100000 == 0:
            print(str(num_popped)+" positions examined")

        if current == goal:
            return reconstruct_path(current)

        for neighbor in current.neighbors():

            # The distance from start to a neighbor
            # All nodes are 1 move from their neighbors

            tentative_gScore = current.gscore + 1

            # update gscore and fscore if this is shorter path
            # to the neighbor node

            if tentative_gScore < neighbor.gscore:
                neighbor.cameFrom = current
                neighbor.gscore = tentative_gScore
                neighbor.fscore = neighbor.gscore + hob.heuristic(neighbor)
                openSet.push(neighbor) # add to open set every time


def find_zero(tiles):
    """ file the 0 tile """
    for row in range(4):
        for col in range(4):
            if tiles[row][col] == 0:
                return (row, col)

def path_as_0_moves(path):
    """
    Takes the path which is a list of Position
    objects and outputs it as a string of rlud
    directions to match output desired by
    Rosetta Code task.
    """
    strpath = ""
    if len(path) < 1:
        return ""
    prev_pos = path[0]
    p_row, p_col = find_zero(prev_pos.tiles)
    for i in range(1,len(path)):
        curr_pos = path[i]
        c_row, c_col = find_zero(curr_pos.tiles)
        if c_row > p_row:
            strpath += 'd'
        elif c_row < p_row:
            strpath += 'u'
        elif c_col > p_col:
            strpath += 'r'
        elif c_col < p_col:
            strpath += 'l'
        # reset for next loop
        prev_pos = curr_pos
        p_row = c_row
        p_col = c_col
    return strpath
