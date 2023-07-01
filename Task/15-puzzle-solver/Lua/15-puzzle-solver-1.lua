#!/usr/bin/lua
--[[
Solve 3X3 sliding tile puzzle using Astar on Lua. Requires 3mb and
millions of recursions.
by RMM  2020-may-1
]]--

local SOLUTION_LIMIT, MAX_F_VALUE = 100,100
local NR, NC, RCSIZE  = 4,4,4*4
local Up, Down, Right, Left = 'u','d','r','l'
local G_cols = {}  -- goal columns
local G_rows = {} -- goal rows
local C_cols = {} -- current cols
local C_rows = {} -- current rows
local Goal = {}
local Tiles = {}		-- the puzzle
local Solution = {}		-- final path is instance of desc
local desc  = {}		-- descending path
desc[0] = 0 -- override Lua default "1" index

-- @brief create C compatible array for Lua
local function Amake( list )
   array = {}
   for i=0, #list do
      array[i] = list[i+1] -- simulate "C" array in Lua
   end
   return array
end

G_cols= Amake({0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, } )
G_rows= Amake({0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, } )
C_cols= Amake({0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, } )
C_rows= Amake({0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, } )
Tiles = Amake({ 15,14,1,6,  9,11,4,12,  0,10,7,3, 13,8,5,2,} )
Goal  = Amake({1,2,3,4, 5,6,7,8, 9,10,11,12, 13,14,15,0,} )

local m1 = {recursions=0, found=0, threshold=0, times=0, steps=0,}
-- ---------------------------------------------------------------
-- return 1D array index given 2D row,column
local function rcidx( row, col )
   return (row * NR + col)
end

-- @brief recursive search
-- @return f_score
local function search( depth, x_row, x_col, h_score)
   local move, go_back_move, last_move_by_current
   local f_score, ix, min, temp, hscore2, idx1
   local N_minus_one = NR - 1;
   local rc1 = {row=0,col=0}
   local rc2 = {row=0,col=0}
   local gtmp = {row=0,col=0}

   f_score = depth + h_score;
   if f_score > m1.threshold then  return f_score end
   if h_score == 0 then do
      m1.found = 1
      Solution = table.concat(desc)
      return f_score  end end

   m1.recursions = m1.recursions+1
   m1.times = m1.times + 1
   if m1.times > 200000 then do
	 print("Recursions ",m1.recursions)
	 m1.times = 0
   end  end

   min = 999999
   last_move_by_current = desc[depth];
   rc1.row = x_row;
   rc1.col = x_col;
   for ix = 0,3 do
      if ix==0 then do
	    move = Up;
	    go_back_move = Down;
	    rc2.row = x_row - 1;
	    rc2.col = x_col;
		   end
      elseif ix==1 then do
	    move = Down;
	    go_back_move = Up;
	    rc2.row = x_row + 1;
	    rc2.col = x_col;
		       end
      elseif ix==2 then do
	    move = Left;
	    go_back_move = Right;
	    rc2.row = x_row;
	    rc2.col = x_col - 1;
		       end
      elseif ix==3 then do
	    move = Right;
	    go_back_move = Left;
	    rc2.row = x_row;
	    rc2.col = x_col + 1;
			end end
      if move==Up and x_row==0 then goto next end
      if move==Down and x_row==N_minus_one then goto next end
      if move==Left and x_col==0 then goto next end
      if move==Right and x_col==N_minus_one then goto next end
      if last_move_by_current==go_back_move then goto next end
      hscore2 = h_score
      idx1 = Tiles[rcidx(rc2.row,rc2.col)]
      gtmp.row = G_rows[idx1]
      gtmp.col = G_cols[idx1]
      local h_adj=0
      if go_back_move==Up then do
	    if gtmp.row < C_rows[idx1] then
	       h_adj = -1 else h_adj = 1 end end
      end
      if go_back_move==Down then do
	    if gtmp.row > C_rows[idx1] then
	       h_adj = -1 else h_adj = 1 end end
      end
      if go_back_move==Left then do
	    if gtmp.col < C_cols[idx1] then
	       h_adj = -1 else h_adj = 1 end end
      end
      if go_back_move==Right then do
	    if gtmp.col > C_cols[idx1] then
	       h_adj = -1 else h_adj = 1 end end
      end
      hscore2 = hscore2 + h_adj
      C_rows[0] = rc2.row;
      C_cols[0] = rc2.col;
      C_rows[idx1] = rc1.row;
      C_cols[idx1] = rc1.col;
      Tiles[rcidx(rc1.row,rc1.col)] = idx1;
      Tiles[rcidx(rc2.row,rc2.col)] = 0;
      desc[depth+1] = move
      desc[depth+2] = '\0'

      temp = search(depth+1, rc2.row, rc2.col, hscore2); -- descend
      -- regress
      Tiles[rcidx(rc1.row,rc1.col)] = 0
      Tiles[rcidx(rc2.row,rc2.col)] = idx1
      desc[depth+1] = '\0'
      C_rows[0] = rc1.row;
      C_cols[0] = rc1.col;
      C_rows[idx1] = rc2.row;
      C_cols[idx1] = rc2.col;
      if m1.found == 1 then return temp end
      if temp < min then  min = temp end
      ::next::  -- Lua does not have "continue;" so uses goto
   end  -- end for
   m1.found = 0;
   -- return the minimum f_score greater than m1.threshold
   return min;
end

-- @brief  Run solver using A-star algorithm
-- @param Tiles .. 3X3 sliding tile puzzle
local function solve(Tiles)
    local temp, i,j
    local x_row, x_col, h_score = 0,0,0

    m1.found = 0;
    for i=0,(NR-1) do
       for j=0, (NC-1) do
	  G_rows[ Goal[rcidx(i,j)] ] = i;
	  G_cols[ Goal[rcidx(i,j)] ] = j;
	  C_rows[ Tiles[rcidx(i,j)] ] = i;
	  C_cols[ Tiles[rcidx(i,j)] ] = j;
       end
    end

    for i=0,(NR-1) do
       for j=0, (NC-1) do
	  if Tiles[rcidx(i,j)] == 0 then do
		x_row = i;
		x_col = j;
		break;
					 end
	  end
       end
    end

   desc[0] = '$'
   desc[1] = '\0'

   h_score = 0;   -- Manhattan/Taxicab heuristic
   for  i = 1,(RCSIZE-1) do
      h_score = h_score + (math.abs(C_rows[i] - G_rows[i]) +
		    math.abs(C_cols[i] - G_cols[i]))
   end
   m1.threshold = h_score
   print("solve -> search")
   while true do
      temp = search( 0, x_row, x_col, h_score);
      if m1.found == 1 then do
	    print("Gound solution of length",#Solution-1)
	    print(Solution)
	    break;
      end end

      if temp > MAX_F_VALUE then do
	    print("Maximum f value reached! terminating! \n");
	    break;	 end
      end
      m1.threshold = temp;
   end -- while
   return 0
end

-- show sliding tile puzzle rows and columns
local function print_tiles( pt)
   local i,j,num
    for i=0,(NR-1) do
       for j=0, (NC-1) do
	  num = pt[rcidx(i,j)]
	  io.write(string.format("%02d ", num))
       end
       print("")
    end
    print("")
end

-- main(void) {
print("Solve sliding 15 tile puzzle");
m1.recursions = 0
m1.times=0
print_tiles(Tiles);
print_tiles(Goal)
solve(Tiles);
