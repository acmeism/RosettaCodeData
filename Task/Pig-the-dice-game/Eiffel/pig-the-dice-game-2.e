class
	PIG_THE_DICE

feature
	play
	local
		points, i: INTEGER
	do
		io.put_string("Welcome to the game.%N")
		initiate_players
		from

		until
			winner/=void
		loop
			across player as p  loop
			points:=p.item.throw_dice
			io.put_string ("%N" + p.item.name +" you throwed " + points.out + ".%N")
			if points =1 then
				io.put_string ("You loose your points.%N")
			else
				p.item.strategy(points)
			end
			if p.item.points >=100 then
				winner := p.item
				io.put_string ("%NThe winner is " + winner.name.out + ".%N")
			end
			end
		end
	end

	initiate_players
	local
		p1,p2: PLAYER
	do
		create player.make (1, 2)
		create p1.set_name ("Player1")
		player.put (p1, 1)
		create p2.set_name ("Player2")
		player.put (p2, 2)
	end

	player: V_ARRAY[PLAYER]
	winner: PLAYER
end
