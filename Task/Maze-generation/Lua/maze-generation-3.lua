require "maze"

-- Backtracker algorithm (a variation of the recursive backtracker algorithm made without recursion)
function Maze:Backtracker(maze)
  maze:resetDoors(true)

  local stack = Stack:Create()

  local cell = { x = 1, y = 1 }
  while true do
    maze[cell.y][cell.x].visited = true

    -- Gathering all possible travel direction in a list
    local directions = {}
    for key, value in pairs(self.directions) do
      local newPos = { x = cell.x + value.x, y = cell.y + value.y }
      -- Checking if the targeted cell is in bounds and was not visited previously
      if maze[newPos.y] and maze[newPos.y][newPos.x] and not maze[newPos.y][newPos.x].visited then
        directions[#directions + 1] = { name = key, pos = newPos }
      end
    end

    -- If there are no possible travel directions - backtracking
    if #directions == 0 then
      if #stack > 0 then
        cell = stack:pop()
        goto countinue
      else break end -- Stack is empty and there are no possible directions - maze is generated
    end

    -- Choosing a random direction from a list of possible direction and carving
    stack:push(cell)
    local dir = directions[math.random(#directions)]
    maze[cell.y][cell.x][dir.name]:open()
    cell = dir.pos

    ::countinue::
  end

  maze:resetVisited()
end
