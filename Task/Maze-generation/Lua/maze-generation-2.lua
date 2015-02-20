require "stack"

Maze =
{
  directions =
  {
    north = { x = 0, y = -1 },
    east = { x = 1, y = 0 },
    south = { x = 0, y = 1 },
    west = { x = -1, y = 0 }
  }
}

function Maze:Create(width, height, closed)
  -- Actual maze setup
  local maze = {}
  for y = 1, height do
    maze[y] = {}
    for x = 1, width do
      maze[y][x] = { east = self:CreateDoor(closed), south = self:CreateDoor(closed)}

      -- Doors are shared beetween the cells to avoid out of sync conditions and data dublication
      if x ~= 1 then maze[y][x].west = maze[y][x - 1].east
      else maze[y][x].west = self:CreateDoor(closed) end

      if y ~= 1 then maze[y][x].north = maze[y - 1][x].south
      else maze[y][x].north = self:CreateDoor(closed) end
    end
  end

  function maze:resetDoors(close)
    for y = 1, #self do
      self[y][#self[1]].east:setOpened(not close)

      for i, cell in ipairs(self[y]) do
        cell.north:setOpened(not close)
        cell.west:setOpened(not close)
      end
    end

    for i, cell in ipairs(self[#self]) do
      cell.south:setOpened(not close)
    end
  end

  function maze:resetVisited()
    for y = 1, #self do
      for x = 1, #self[1] do
        self[y][x].visited = nil
      end
    end
  end

  function maze:tostring(wall, passage)
    wall = wall or "#"
    passage = passage or " "

    local result = ""

    local verticalBorder = ""
    for i = 1, #self[1] do
      verticalBorder = verticalBorder .. wall .. (self[1][i].north:isClosed() and wall or passage)
    end
    verticalBorder = verticalBorder .. wall
    result = result .. verticalBorder .. "\n"

    for y, row in ipairs(self) do
      local line = row[1].west:isClosed() and wall or passage
      local underline = wall
      for x, cell in ipairs(row) do
        line = line .. " " .. (cell.east:isClosed() and wall or passage)
        underline = underline .. (cell.south:isClosed() and wall or passage) .. wall
      end
      result = result .. line .. "\n" .. underline .. "\n"
    end

    return result
  end

  return maze
end


-- This function was designed to be easily replaced by the function generating Legend of Grimrock doors
function Maze:CreateDoor(closed)
  local door = {}
  door._closed = closed and true or false

  function door:isClosed()
    return self._closed
  end

  function door:isOpened()
    return not self._closed
  end

  function door:close()
    self._closed = true
  end

  function door:open()
    self._closed = false
  end

  function door:setOpened(opened)
    if opened then
      self:open()
    else
      self:close()
    end
  end

  return door
end
