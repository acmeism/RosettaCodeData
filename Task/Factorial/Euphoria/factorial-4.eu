include std/mathcons.e

enum MUL_LLL,
	TESTEQ_LIL,
	TESTLT_LIL,
	TRUEGO_LL,
	MOVE_LL,
	INCR_L,
	TESTGT_LLL,
	GOTO_L,
	OUT_LI,
	OUT_II,
	STOP
	
global sequence tape = {
	1,
	1,
	0,
	0,
	0,
	{TESTLT_LIL, 5, 0, 4},
	{TRUEGO_LL, 4, 22},
	{TESTEQ_LIL, 5, 0, 4},
	{TRUEGO_LL, 4, 20},
	{MUL_LLL, 1, 2, 3},
	{TESTEQ_LIL, 3, PINF, 4},
	{TRUEGO_LL, 4, 18},
	{MOVE_LL, 3, 1},
	{INCR_L, 2},
	{TESTGT_LLL, 2, 5, 4 },
	{TRUEGO_LL, 4, 18},
	{GOTO_L, 10},
	{OUT_LI, 3, "%.0f\n"},
	{STOP},
	{OUT_II, 1, "%.0f\n"},
	{STOP},
	{OUT_II, "Negative argument", "%s\n"},
	{STOP}
}

global integer ip = 1

procedure eval( sequence cmd )
	atom i = 1
	while i <= length( cmd ) do
		switch cmd[ i ] do
			case MUL_LLL then -- multiply location location giving location
				tape[ cmd[ i + 3 ] ] = tape[ cmd[ i + 1 ] ] * tape[ cmd[ i + 2 ] ]
				i += 3
			case TESTEQ_LIL then -- test if location eq value giving location
				tape[ cmd[ i + 3 ]] = ( tape[ cmd[ i + 1 ] ] = cmd[ i + 2 ] )
				i += 3
			case TESTLT_LIL then -- test if location eq value giving location
				tape[ cmd[ i + 3 ]] = ( tape[ cmd[ i + 1 ] ] < cmd[ i + 2 ] )
				i += 3
			case TRUEGO_LL then -- if true in location, goto location
				if tape[ cmd[ i + 1 ] ] then
					ip = cmd[ i + 2 ] - 1
				end if
				i += 2
			case MOVE_LL then -- move value at location to location
				tape[ cmd[ i + 2 ] ] = tape[ cmd[ i + 1 ] ]
				i += 2
			case INCR_L then -- increment value at location
				tape[ cmd[ i + 1 ] ] += 1
				i += 1
			case TESTGT_LLL then -- test if location gt location giving location
				tape[ cmd[ i + 3 ]] = ( tape[ cmd[ i + 1 ] ] > tape[ cmd[ i + 2 ] ] )
				i += 3
			case GOTO_L then -- goto location
				ip = cmd[ i + 1 ] - 1
				i += 1
			case OUT_LI then -- output location using format
				printf( 1, cmd[ i + 2], tape[ cmd[ i + 1 ] ] )
				i += 2
			case OUT_II then -- output immediate using format
				if sequence( cmd[ i + 1 ] ) then
					printf( 1, cmd[ i + 2], { cmd[ i + 1 ] } )
				else
					printf( 1, cmd[ i + 2], cmd[ i + 1 ] )
				end if
				i += 2
			case STOP then -- stop
				abort(0)
		end switch
		i += 1
	end while
end procedure

include std/convert.e

sequence cmd = command_line()
if length( cmd ) > 2 then
	puts( 1, cmd[ 3 ] & "! = " )
	tape[ 5 ] = to_number(cmd[3])
else
	puts( 1, "eui fact.ex <number>\n" )
	abort(1)
end if

while 1 do
	if sequence( tape[ ip ] ) then
		eval( tape[ ip ] )
	end if
	ip += 1
end while
