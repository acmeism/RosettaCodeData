local numPlayers = 2
local maxScore = 100
local scores = { }
for i = 1, numPlayers do
	scores[i] = 0  -- total safe score for each player
end
math.randomseed(os.time())
print("Enter a letter: [h]old or [r]oll?")
local points = 0 -- points accumulated in current turn
local p = 1 -- start with first player
while true do
	io.write("\nPlayer "..p..", your score is ".. scores[p]..", with ".. points.." temporary points.  ")
	local reply = string.sub(string.lower(io.read("*line")), 1, 1)
	if reply == 'r' then
		local roll = math.random(6)
		io.write("You rolled a " .. roll)
		if roll == 1 then
			print(".  Too bad. :(")
			p = (p % numPlayers) + 1
			points = 0
		else
			points = points + roll
		end
	elseif reply == 'h' then
		scores[p] = scores[p] + points
		if scores[p] >= maxScore then
			print("Player "..p..", you win with a score of "..scores[p])
			break
		end
		print("Player "..p..", your new score is " .. scores[p])
		p = (p % numPlayers) + 1
		points = 0
	end
end
