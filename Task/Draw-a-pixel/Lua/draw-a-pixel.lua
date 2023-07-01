local SDL = require "SDL"

local ret = SDL.init { SDL.flags.Video }
local window = SDL.createWindow {
	title	= "Pixel",
	height	= 320,
	width	= 240
}

local renderer = SDL.createRenderer(window, 0, 0)

renderer:clear()
renderer:setDrawColor(0xFF0000)
renderer:drawPoint({x = 100,y = 100})
renderer:present()

SDL.delay(5000)
