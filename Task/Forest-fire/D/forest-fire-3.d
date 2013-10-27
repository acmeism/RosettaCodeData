#chance of empty->tree
set :p 0.004
#chance of spontaneous tree combustion
set :f 0.001
#chance of tree in initial state
set :s 0.5
#height of world
set :H 10
#width of world
set :W 20

has-burning-neigbour state pos:
	for i range -- swap ++ dup &< pos:
		for j range -- swap ++ dup &> pos:
			& i j
			try:
				state!
			catch value-error:
				:empty
			if = :burning:
				return true
	false

evolve state pos:
	state! pos
	if = :tree dup:
		if has-burning-neigbour state pos:
			:burning drop
		elseif chance f:
			:burning drop
	elseif = :burning:
		:empty
	else:
		if chance p:
			:tree
		else:
			:empty

step state:
	local :next {}
	for k in keys state:
		set-to next k evolve state k
	next

local :(c) { :tree "T" :burning "B" :empty "." }
print-state state:
	for j range 0 H:
		for i range 0 W:
			print\ (c)! state! & i j
		print ""

init-state:
	local :first {}
	for j range 0 H:
		for i range 0 W:
			if chance s:
				:tree
			else:
				:empty
			set-to first & i j
	first

run:
	init-state
	while true:
		print-state dup
		print ""
		step

run-slowly:
	init-state
	while true:
		print-state dup
		drop input
		step

run
