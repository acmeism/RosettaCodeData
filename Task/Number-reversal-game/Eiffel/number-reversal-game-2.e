class
	APPLICATION
inherit
	ARGUMENTS
create
	make
feature {NONE} -- Initialization
	make
		do
			create nr
			nr.play_game
		end
	nr: NUMBER_REVERSAL_GAME
end
