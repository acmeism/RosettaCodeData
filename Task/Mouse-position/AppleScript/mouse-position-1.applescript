use application "System Events"

property process : a reference to (first process whose frontmost = true)
property window : a reference to front window of my process


set [Wx, Wy] to my window's position
set [Cx, Cy] to {x, y} of the mouse's coordinates()


script mouse
	use framework "Foundation"
	
	property this : a reference to current application
	property NSEvent : a reference to NSEvent of this
	property NSScreen : a reference to NSScreen of this
	
	on coordinates()
		-- Screen dimensions
		set display to NSDeviceSize of deviceDescription() ¬
			of item 1 of NSScreen's screens() as record
		
		-- Mouse position relative to bottom-left of screen
		set mouseLoc to (NSEvent's mouseLocation as record)
		-- Flip mouse y-coordinate so it's relative to top of screen
		set mouseLoc's y to (display's height) - (mouseLoc's y)
		
		mouseLoc
	end coordinates
end script
