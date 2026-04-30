Red [ "Compose Two or Any Number of Functions - Hinjolicious" ]

; to show the codes
demo: function [s b] [print ["^/==" s "==^/"] print mold/only b do b]

demo "Compose two functions" [
comp-func: function ['f 'g] [function [x] compose [(get f) (get g) x]]
sin-cos: comp-func sin cos
print sin-cos 0.5
]

demo "Compose any number of functions" [
comp-funcs: function [ff] [
	function [x] compose append collect [foreach e ff [keep (get e)]] 'x
]
log-sin-cos: comp-funcs [log-e sin cos]
print log-sin-cos 0.5
]
