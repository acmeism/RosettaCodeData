class
	APPLICATION
inherit
	ARGUMENTS
create
	make
feature {NONE} -- Initialization
	make
	local
		do
			create pig
			pig.initiate_players
			pig.play
		end
	pig: PIG_THE_DICE
end
