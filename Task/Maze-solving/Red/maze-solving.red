Red ["Maze solver"]

do %mazegen.red	
print [
	"start:" start: random size - 1x1
	"end:" end: random size - 1x1
]
isnew?: function [pos] [not find visited pos]
open?: function [pos d] [
	o: pos/y * size/x + pos/x + 1
	0 = pick walls/:o d
]
expand: function [pos][
	either any [
		all [pos/x > 0 isnew? p: pos - 1x0 open? p 1]
		all [pos/x < (size/x - 1) isnew? p: pos + 1x0 open? pos 1]
		all [pos/y > 0 isnew? p: pos - 0x1 open? p 2]
		all [pos/y < (size/y - 1) isnew? p: pos + 0x1 open? pos 2]
	][append visited p insert path p][remove path]
	path/1
]
path: reduce [start]
visited: []
until [end = expand path/1]
print reverse path
