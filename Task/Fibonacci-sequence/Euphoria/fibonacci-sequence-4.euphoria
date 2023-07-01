include std/mathcons.e -- for PINF constant

enum ADD, MOVE, GOTO, OUT, TEST, TRUETO

global sequence tape = { 0,
			 1,
		       { ADD, 2, 1 },
		       { TEST, 1, PINF },
		       { TRUETO, 0 },
		       { OUT, 1, "%.0f\n" },
		       { MOVE, 2, 1 },
		       { MOVE, 0, 2 },
		       { GOTO, 3  } }

global integer ip
global integer test
global atom accum

procedure eval( sequence cmd )
	atom i = 1
	while i <= length( cmd ) do
		switch cmd[ i ] do
			case ADD then
				accum = tape[ cmd[ i + 1 ] ] + tape[ cmd[ i + 2 ] ]
				i += 2

			case OUT then
				printf( 1, cmd[ i + 2], tape[ cmd[ i + 1 ] ] )
				i += 2

			case MOVE then
				if cmd[ i + 1 ] = 0 then
					tape[ cmd[ i + 2 ] ] = accum
				else
					tape[ cmd[ i + 2 ] ] = tape[ cmd[ i + 1 ] ]
				end if
				i += 2

			case GOTO then
				ip = cmd[ i + 1 ] - 1 -- due to ip += 1 in main loop
				i += 1

			case TEST then
				if tape[ cmd[ i + 1 ] ] = cmd[ i + 2 ] then
					test = 1
				else
					test = 0
				end if
				i += 2

			case TRUETO then
				if test then
					if cmd[ i + 1 ] = 0 then
						abort(0)
					else
						ip = cmd[ i + 1 ] - 1
					end if
				end if

		end switch
		i += 1
	end while
end procedure

test = 0
accum = 0
ip = 1

while 1 do

	-- embedded sequences (assumed to be code) are evaluated
	-- atoms (assumed to be data) are ignored

	if sequence( tape[ ip ] ) then
		eval( tape[ ip ] )
	end if
	ip += 1
end while
