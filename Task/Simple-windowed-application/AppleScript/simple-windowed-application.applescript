set counter to 0

set dialogReply to display dialog ¬
	"There have been no clicks yet" buttons {"Click Me", "Quit"} ¬
	with title "Simple Window Application"
set theAnswer to button returned of the result
if theAnswer is "Quit" then quit

repeat
	set counter to counter + 1
	set dialogReply to display dialog counter buttons {"Click Me", "Quit"} ¬
		with title "Simple Window Application"
	set theAnswer to button returned of the result
	if theAnswer is "Quit" then exit repeat
end repeat
