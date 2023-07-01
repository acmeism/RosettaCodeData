math.randomseed( os.time() )

-- Fisher-Yates shuffle from http://santos.nfshost.com/shuffling.html
function shuffle(t)
  for i = 1, #t - 1 do
    local r = math.random(i, #t)
    t[i], t[r] = t[r], t[i]
  end
end

-- builds a width-by-height grid of trues
function initialize_grid(w, h)
  local a = {}
  for i = 1, h do
    table.insert(a, {})
    for j = 1, w do
      table.insert(a[i], true)
    end
  end
  return a
end

-- average of a and b
function avg(a, b)
  return (a + b) / 2
end


dirs = {
  {x = 0, y = -2}, -- north
  {x = 2, y = 0}, -- east
  {x = -2, y = 0}, -- west
  {x = 0, y = 2}, -- south
}

function make_maze(w, h)
  w = w or 16
  h = h or 8

  local map = initialize_grid(w*2+1, h*2+1)

  function walk(x, y)
    map[y][x] = false

    local d = { 1, 2, 3, 4 }
    shuffle(d)
    for i, dirnum in ipairs(d) do
      local xx = x + dirs[dirnum].x
      local yy = y + dirs[dirnum].y
      if map[yy] and map[yy][xx] then
        map[avg(y, yy)][avg(x, xx)] = false
        walk(xx, yy)
      end
    end
  end

  walk(math.random(1, w)*2, math.random(1, h)*2)

  local s = {}
  for i = 1, h*2+1 do
    for j = 1, w*2+1 do
      if map[i][j] then
        table.insert(s, '#')
      else
        table.insert(s, ' ')
      end
    end
    table.insert(s, '\n')
  end
  return table.concat(s)
end

print(make_maze())
