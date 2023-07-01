-- main.lua
function newGame ()
	-- new deck
	local deck = {}
	for iSuit = 1, #CardSuits do
		for iRank = 1, #CardRanks do
			local card = {
				iSuit = iSuit,
				iRank = iRank,
				suit = CardSuits[iSuit],
				rank = iRank,
				name = CardRanks[iRank] .. CardSuits[iSuit]
			}
			local i = math.random (#deck + 1)
			table.insert (deck, i, card)
		end
	end
	
	-- new deal
	Players = {
		{index = 1, cards = {}},
		{index = 2, cards = {}},
	}
	for i = 1, #deck/#Players do
		for iPlayer = 1, #Players do
			table.insert (Players[iPlayer].cards, table.remove(deck))
		end
	end
	WarCards = {}
	Turn = 1
	Statistics = {}
end

function getHigherCard (cardA, cardB)
	if cardA.rank > cardB.rank then
		return cardA, 1
	elseif cardA.rank < cardB.rank then
		return cardB, 2
	else
		return nil
	end
end

function love.load()
	-- there is no card suits in the standard font
	CardSuits = {"@", "#", "$", "%"}
	CardRanks = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "V", "Q", "K", "A"}
	
	newGame ()
end

function love.draw()
	for iPlayer = 1, #Players do
		local player = Players[iPlayer]
		love.graphics.print ('Player '..player.index, 50*(iPlayer-1), 0)
		for iCard, card in ipairs (player.cards) do
			love.graphics.print (card.name, 50*(iPlayer-1), 14*iCard)
		end
	end
	for i = 1, math.min(40, #Statistics) do
		local str = Statistics[i]
		love.graphics.print (str, 150, 20+(i-1)*14)
	end
	
end

function makeTurn ()
	local card1 = table.remove (Players[1].cards)
	local card2 = table.remove (Players[2].cards)
	if card1 and card2 then
		table.insert (WarCards, 1, card1)
		table.insert (WarCards, math.random (1, 2), card2)
		local winCard, index = getHigherCard (card1, card2)
		if winCard then
			table.insert (Statistics, 1, Turn .. '	Player ' .. index .. ' get ' .. #WarCards .. ' cards: ' .. card1.name .. ' vs ' .. card2.name)
			
			for iCard = #WarCards, 1, -1 do
				table.insert (Players[index].cards, 1, table.remove (WarCards))
			end
		elseif (#Players[1].cards > 0) and (#Players[2].cards > 0) then
		-- start war
			table.insert (Statistics, 1, Turn .. '	War: ' .. card1.name .. ' vs ' .. card2.name)
			table.insert (WarCards, table.remove (Players[1].cards))
			table.insert (WarCards, table.remove (Players[2].cards))
		else
			local index = 2
			if #Players[1].cards == 0 then index = 1 end
			table.insert (Statistics, 1, Turn .. '	Player ' .. index .. ' has no cards for this war.')
--			GameOver = true
		end
		Turn = Turn + 1
	elseif GameOver then
		GameOver = false
		newGame ()
	else
		local index = 2
		if #Players[1].cards > #Players[2].cards then index = 1 end
		table.insert (Statistics, 1, Turn .. '	Player ' .. index .. ' wins the game!')
		GameOver = true
	end
end

function love.keypressed(key, scancode, isrepeat)
	if false then
	elseif key == "space" then
		makeTurn ()
	elseif scancode == "n" then
		GameOver = false
		newGame ()
	elseif scancode == "q" then
		local lastTurn = Turn
		while not (GameOver or (Turn > lastTurn + 10000-1)) do
			makeTurn ()
		end
	elseif key == "escape" then
		love.event.quit()
	end
	if #Statistics > 40 then
		local i = #Statistics, 40, -1 do
			table.remove (Statistics, i)
		end
	end
end

function love.mousepressed( x, y, button, istouch, presses )
	if button == 1 then -- left mouse button
		makeTurn ()
	elseif button == 2 then -- right mouse button
	end
end
