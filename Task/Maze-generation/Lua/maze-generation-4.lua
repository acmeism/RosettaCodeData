require "maze"
require "backtracker"

maze = Maze:Create(30, 10, true)
--[[  Maze generation depends on the random seed, so you will get exactly
      identical maze every time you pass exactly identical seed ]]
math.randomseed(os.time())
Maze:Backtracker(maze)
print(maze:tostring())
