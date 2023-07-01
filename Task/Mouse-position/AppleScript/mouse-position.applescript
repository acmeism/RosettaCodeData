use framework "AppKit"

tell application id "com.apple.SystemEvents" to tell ¬
	(the first process where it is frontmost) to ¬
	set {x, y} to the front window's position

tell the current application
	set H to NSHeight(its NSScreen's mainScreen's frame)
	tell [] & its NSEvent's mouseLocation
		set item 1 to (item 1) - x
		set item 2 to H - (item 2) - y
		set coords to it as point
	end tell
end tell

log coords
