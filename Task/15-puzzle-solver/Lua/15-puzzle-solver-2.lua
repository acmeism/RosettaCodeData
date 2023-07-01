----------
-- SOLVER
----------

local table_concat = table.concat -- local alias

local function Solver(root, h, successors)
  local pathlist, pathhash, iters
  -- it is required that "h(node)" returns:
  --   0 when "is_goal(node)==true"
  --   >0 when "is_goal(node)==false"
  --   (because it allows for some simplification herein)
  local FOUND = 0 -- ie: "is_goal(node)==true"
  local NOT_FOUND = 1e9 -- some number larger than largest possible f

  local function hash(node)
    return table_concat(node,",")
  end

  local function search(g, bound)
    iters = iters + 1
    --if ((iters % 1000000) == 0) then print("iterations:", iters) end
    local node = pathlist[#pathlist]
    local h = h(node)
    local f = g + h
    if (f > bound) then return f end
    if (h == FOUND) then return FOUND end
    local min = NOT_FOUND
    for succ, cost in successors(node) do
      local succhash = hash(succ)
      if (not pathhash[succhash]) then
        pathlist[#pathlist+1], pathhash[succhash] = succ, true
        local t = search(g+cost, bound)
        if (t == FOUND) then return FOUND end
        if (t < min) then min = t end
        pathlist[#pathlist], pathhash[succhash] = nil, nil
      end
    end
    return min
  end

  return {
    solve = function()
      pathlist = { root }
      pathhash = { [hash(root)] = true }
      iters = 0
      local bound = h(root)
      while true do
        bound = search(0, bound)
        if (bound == FOUND) then return bound, iters, pathlist end
        if (bound == NOT_FOUND) then return bound, iters, nil end
      end
    end
  }
end

------------------
-- DOMAIN SUPPORT
------------------

local i2c = { [0]=0, 1,2,3,4, 1,2,3,4, 1,2,3,4, 1,2,3,4 } -- convert index to column
local i2r = { [0]=0, 1,1,1,1, 2,2,2,2, 3,3,3,3, 4,4,4,4 } -- convert index to row
local R, U, L, D = 1, -4, -1, 4 -- move indexing values
local movenames = { -- move names
  [0]="", [R]="r", [U]="u", [L]="l", [D]="d"
}
local succmoves = { -- successor directions
  {R,D}, {R,L,D}, {R,L,D}, {L,D},
  {R,U,D}, {R,U,L,D}, {R,U,L,D}, {U,L,D},
  {R,U,D}, {R,U,L,D}, {R,U,L,D}, {U,L,D},
  {R,U}, {R,U,L}, {R,U,L}, {U,L}
}
local manhdists = { -- manhattan distances
  { [0]=0, 0, 1, 2, 3, 1, 2, 3, 4, 2, 3, 4, 5, 3, 4, 5, 6 },
  { [0]=0, 1, 0, 1, 2, 2, 1, 2, 3, 3, 2, 3, 4, 4, 3, 4, 5 },
  { [0]=0, 2, 1, 0, 1, 3, 2, 1, 2, 4, 3, 2, 3, 5, 4, 3, 4 },
  { [0]=0, 3, 2, 1, 0, 4, 3, 2, 1, 5, 4, 3, 2, 6, 5, 4, 3 },
  { [0]=0, 1, 2, 3, 4, 0, 1, 2, 3, 1, 2, 3, 4, 2, 3, 4, 5 },
  { [0]=0, 2, 1, 2, 3, 1, 0, 1, 2, 2, 1, 2, 3, 3, 2, 3, 4 },
  { [0]=0, 3, 2, 1, 2, 2, 1, 0, 1, 3, 2, 1, 2, 4, 3, 2, 3 },
  { [0]=0, 4, 3, 2, 1, 3, 2, 1, 0, 4, 3, 2, 1, 5, 4, 3, 2 },
  { [0]=0, 2, 3, 4, 5, 1, 2, 3, 4, 0, 1, 2, 3, 1, 2, 3, 4 },
  { [0]=0, 3, 2, 3, 4, 2, 1, 2, 3, 1, 0, 1, 2, 2, 1, 2, 3 },
  { [0]=0, 4, 3, 2, 3, 3, 2, 1, 2, 2, 1, 0, 1, 3, 2, 1, 2 },
  { [0]=0, 5, 4, 3, 2, 4, 3, 2, 1, 3, 2, 1, 0, 4, 3, 2, 1 },
  { [0]=0, 3, 4, 5, 6, 2, 3, 4, 5, 1, 2, 3, 4, 0, 1, 2, 3 },
  { [0]=0, 4, 3, 4, 5, 3, 2, 3, 4, 2, 1, 2, 3, 1, 0, 1, 2 },
  { [0]=0, 5, 4, 3, 4, 4, 3, 2, 3, 3, 2, 1, 2, 2, 1, 0, 1 },
  { [0]=0, 6, 5, 4, 3, 5, 4, 3, 2, 4, 3, 2, 1, 3, 2, 1, 0 },
}

--- create a state from a pattern, optionally applying a move
local function state(patt, move)
  local node = {}
  for k,v in pairs(patt) do node[k] = v end
  if (move) then
    local e = node.e
    local ep = e + move
    node[e], node[ep] = node[ep], 0
    node.e, node.m = ep, move
  end
  return node
end

--- iterator for successors of node
local function successors(node)
  local moves = succmoves[node.e]
  local i, n = 0, #moves
  return function()
    i = i + 1
    if (i <= n) then
      return state(node, moves[i]), 1
    end
  end
end

--- hueristic estimate of travel cost from node to goal
local function h(node)
  local sum, ijx, jix, t = 0, 1, 1
  for i = 1, 4 do
    local colmax, rowmax = 0, 0
    for j = 1, 4 do
      t = node[ijx]
      sum = sum + manhdists[ijx][t] -- manhattan
      if (i2r[t] == i) then -- row conflicts
        if (t > rowmax) then rowmax=t else sum=sum+2 end
      end
      t = node[jix]
      if (i2c[t] == i) then -- col conflicts
        if (t > colmax) then colmax=t else sum=sum+2 end
      end
      ijx, jix = ijx+1, jix+4
    end
    jix = jix - 15
  end
  return sum
end

------------------
-- PRINT SUPPORT:
------------------

local function printnode(node)
  print("+--+--+--+--+")
  for i = 0, 12, 4 do
    print( string.format("|%2d|%2d|%2d|%2d|", node[i+1], node[i+2], node[i+3], node[i+4]) )
    print("+--+--+--+--+")
  end
end

local function printpath(path)
  -- note that #path is 1 longer than solution due to root node at path[1]
  -- concatenated result will be correct length since movenames[root.m]==""
  local t = {}
  for i, node in ipairs(path) do
    t[i] = movenames[node.m]
  end
  local pathstr = table_concat(t)
  print("SOLUTION: " .. pathstr .. " (length: " .. #pathstr .. ")")
end

---------
-- TASKS:
---------

-- goal is implied by h(), never actually used (see solver's notes)
-- local goal = state({ 1,2,3,4, 5,6,7,8, 9,10,11,12, 13,14,15,0, e=16, m=0 })

do
  print("PRIMARY TASK (OPTIMALLY)")
  local sclock = os.clock()
  local root = state({ 15,14,1,6, 9,11,4,12, 0,10,7,3, 13,8,5,2, e=9, m=0 })
  printnode(root)
  local solver = Solver(root, h, successors)
  local bound, iters, path = solver:solve()
  printpath(path)
  printnode(path[#path])
  print("ITERATIONS: " .. iters)
  print("ELAPSED: " .. (os.clock()-sclock) .. "s")
end

print()

do
  print("EXTRA CREDIT TASK (APPROXIMATELY, NON-OPTIMALLY)")
  -- only primary task specifies "fewest possible moves"
  -- extra credit task only specifies "solve", so..
  local sclock = os.clock()
  local root = state({ 0,12,9,13, 15,11,10,14, 3,7,2,5, 4,8,6,1, e=1, m=0 })
  printnode(root)
  local function hec(node)
    -- overweighting h makes it not admissible,
    -- causing solver to favor g when minimizing,
    -- leading to non-optimal (but much easier to find!) solutions
    return h(node)*1.5
  end
  local solver = Solver(root, hec, successors)
  local bound, iters, path = solver:solve()
  printpath(path) --> 86, optimal solution is known to be 80
  printnode(path[#path])
  print("ITERATIONS: " .. iters)
  print("ELAPSED: " .. (os.clock()-sclock) .. "s")
end
