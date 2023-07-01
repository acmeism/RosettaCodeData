-- ForestFire automaton implementation
-- Rules: at each step:
-- 1) a burning tree disappears
-- 2) a non-burning tree starts burning if any of its neighbours is
-- 3) an empty spot may generate a tree with prob P
-- 4) a non-burning tree may ignite with prob F

local socket = require 'socket' -- needed for socket.sleep
local curses = require 'curses'

local p_spawn, p_ignite = 0.005, 0.0002
local naptime = 0.03 -- seconds
local forest_x, forest_y = 60, 30

local forest = (function (x, y)
	local wrl = {}
	for i = 1, y do
		wrl[i] = {}
		for j = 1, x do
			local rand = math.random()
			wrl[i][j] = (rand < 0.5) and 1 or 0
		end
	end
	return wrl
end)(forest_x, forest_y)

math.randomseed(os.time())

forest.step = function (self)
	for i = 1, #self do
		for j = 1, #self[i] do
			if self[i][j] == 0 then
				if math.random() < p_spawn then self[i][j] = 1 end
			elseif self[i][j] == 1 then
				if self:ignite(i, j) or math.random() < p_ignite then self[i][j] = 2 end
			elseif self[i][j] == 2 then self[i][j] = 0
			else error("Error: forest[" .. i .. "][" .. j .. "] is " .. self[i][j] .. "!")
			end
		end
	end
end

forest.draw = function (self)
	for i = 1, #self do
		for j = 1, #self[i] do
			if self[i][j] == 0 then win:mvaddch(i,j," ")
			elseif self[i][j] == 1 then
				win:attron(curses.color_pair(1))
				win:mvaddch(i,j,"Y")
				win:attroff(curses.color_pair(1))
			elseif self[i][j] == 2 then
				win:attron(curses.color_pair(2))
				win:mvaddch(i,j,"#")
				win:attroff(curses.color_pair(2))
			else error("self[" .. i .. "][" .. j .. "] is " .. self[i][j] .. "!")
			end
		end
	end
end

forest.ignite = function (self, i, j)
	for k = i - 1, i + 1 do
		if k < 1 or k > #self then goto continue1 end
		for l = j - 1, j + 1 do
			if 	l < 1 or
				l > #self[i] or
				math.abs((k - i) + (l - j)) ~= 1
			then
				goto continue2
			end
			if self[k][l] == 2 then return true end
			::continue2::
		end
		::continue1::
	end
	return false
end

local it = 1
curses.initscr()
curses.start_color()
curses.echo(false)
curses.init_pair(1, curses.COLOR_GREEN, curses.COLOR_BLACK)
curses.init_pair(2, curses.COLOR_RED, curses.COLOR_BLACK)
win = curses.newwin(forest_y + 2, forest_x, 0, 0)
win:clear()
win:mvaddstr(forest_y + 1, 0, "p_spawn = " .. p_spawn .. ", p_ignite = " .. p_ignite)
repeat
	forest:draw()
	win:move(forest_y, 0)
	win:clrtoeol()
	win:addstr("Iteration: " .. it .. ", nap = " .. naptime*1000 .. "ms")
	win:refresh()
	forest:step()
	it = it + 1
	socket.sleep(naptime)
until false
