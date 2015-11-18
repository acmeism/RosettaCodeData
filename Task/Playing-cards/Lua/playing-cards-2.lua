local tPlayers = {} -- cards of players
local tBoard = {}   -- cards in a board
local nPlayers = 5  -- number of players

local tDeck = {
'2d', '3d', '4d', '5d', '6d', '7d', '8d', '9d', 'Td', 'Jd', 'Qd', 'Kd', 'Ad', -- DIAMONDS
'2s', '3s', '4s', '5s', '6s', '7s', '8s', '9s', 'Ts', 'Js', 'Qs', 'Ks', 'As', -- SPADES
'2h', '3h', '4h', '5h', '6h', '7h', '8h', '9h', 'Th', 'Jh', 'Qh', 'Kh', 'Ah', -- HEARTS
'2c', '3c', '4c', '5c', '6c', '7c', '8c', '9c', 'Tc', 'Jc', 'Qc', 'Kc', 'Ac'} -- CLUBS

local function shuffle() -- Fisher–Yates shuffle
  i = #tDeck
  while i > 1 do
    i = i - 1
    j = math.random(1, i)
    tDeck[j], tDeck[i] = tDeck[i], tDeck[j]
  end
  return tDeck
end

local function cardTransfer(to, amount, from)
  for f = 1, amount do
	table.insert(to, #to+1, from[#from])
	from[#from] = nil
  end
end

----||EXAMPLE OF USE||----
print('FRESH DECK \n', table.concat(tDeck, ' '), '\n')

shuffle()

print('SHUFFLED DECK \n', table.concat(tDeck, ' '), '\n')

for a = 1, nPlayers do
  tPlayers[a] = {}
  cardTransfer(tPlayers[a], 2, tDeck)
end

cardTransfer(tBoard, 5, tDeck)

print('BOARD\n', table.concat(tBoard, ' '), '\n')

for b = 1, nPlayers do
  print('PLAYER #'..b..': ', table.concat(tPlayers[b], ' '))
end

print('\nREMAINING\n', table.concat(tDeck, ' '), '\n')

for c = 1, #tPlayers do
  for d = 1, #tPlayers[c] do
    cardTransfer(tDeck, d, tPlayers[c])
  end
end

cardTransfer(tDeck, 5, tBoard)

print('ALL CARDS IN THE DECK\n', table.concat(tDeck, ' '), '\n')
