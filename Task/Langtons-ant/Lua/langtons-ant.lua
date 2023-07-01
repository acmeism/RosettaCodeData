local socket = require 'socket' -- needed for socket.sleep
local curses = require 'curses' -- used for graphics

local naptime = 0.02 -- seconds
local world_x, world_y = 100, 100

local world = (function (x, y)
	local wrl = {}
	for i = 1, y do
		wrl[i] = {}
		for j = 1, x do
			wrl[i][j] = 0
		end
	end
	return wrl
end)(world_x, world_y)

-- directions: 0 up, clockwise
local ant = {
	x = math.floor(world_x / 2),
	y = math.floor(world_y / 2),
	dir = 0,
	step = function(self)
		if self.dir == 0 then self.y = self.y - 1
		elseif self.dir == 1 then self.x = self.x + 1
		elseif self.dir == 2 then self.y = self.y + 1
		else self.x = self.x - 1
		end
	end
}

world.step = function (self, ant)
	if self[ant.y][ant.x] == 0 then	-- white
		-- change cell color
		self[ant.y][ant.x] = 1
		-- change dir
		ant.dir = (ant.dir + 1) % 4
		ant:step()
		-- boundary conditions
		if ant.x < 1 then ant.x = world_x
		elseif ant.x > world_x then ant.x = 1
		end
		if ant.y < 1 then ant.y = world_y
		elseif ant.y > world_y then ant.y = 1
		end
	else
		-- change cell color
		self[ant.y][ant.x] = 0
		-- change dir
		ant.dir = (ant.dir - 1) % 4
		ant:step()
		-- boundary conditions
		if ant.x < 1 then ant.x = world_x
		elseif ant.x > world_x then ant.x = 1
		end
		if ant.y < 1 then ant.y = world_y
		elseif ant.y > world_y then ant.y = 1
		end
	end
end

world.draw = function (self, ant)
	for i = 1, #self do
		for j = 1, #self[i] do
			if i == ant.y and j == ant.x then
				win:attron(curses.color_pair(3))
				win:mvaddch(i,j,"A")
				--win:attroff(curses.color_pair(3))
			elseif self[i][j] == 0 then
				win:attron(curses.color_pair(1))
				win:mvaddch(i,j," ")
				--win:attroff(curses.color_pair(1))
			elseif self[i][j] == 1 then
				win:attron(curses.color_pair(2))
				win:mvaddch(i,j," ")
				--win:attroff(curses.color_pair(2))
			else error("self[" .. i .. "][" .. j .. "] is " .. self[i][j] .. "!")
			end
		end
	end
end

local it = 1
curses.initscr()
curses.start_color()
curses.echo(false)
curses.init_pair(1, curses.COLOR_WHITE, curses.COLOR_WHITE)
curses.init_pair(2, curses.COLOR_BLACK, curses.COLOR_BLACK)
curses.init_pair(3, curses.COLOR_RED, curses.COLOR_WHITE)
curses.init_pair(4, curses.COLOR_WHITE, curses.COLOR_BLACK)
win = curses.newwin(world_y + 1, world_x, 0, 0)
win:clear()
repeat
	world:draw(ant)
	win:move(world_y, 0)
	win:clrtoeol()
	win:attron(curses.color_pair(4))
	win:addstr("Iteration: " .. it .. ", nap = " .. naptime*1000 .. "ms")
	win:refresh()
	world:step(ant)
	it = it + 1
	--local c = stdscr:getch()
	--if c == '+' then naptime = naptime - (naptime / 10)
	--elseif c == '-' then naptime = naptime + (naptime / 10)
	--end
	socket.sleep(naptime)
until false
