function cpuMove()
  local totalChance = record.R + record.P + record.S
  if totalChance == 0 then  -- First game, unweighted random
    local choice = math.random(1, 3)
    if choice == 1 then return "R" end
    if choice == 2 then return "P" end
    if choice == 3 then return "S" end
  end
  local choice = math.random(1, totalChance)  -- Weighted random bit
  if choice <= record.R then return "P" end
  if choice <= record.R + record.P then return "S" end
  return "R"
end

function playerMove()  -- Get user input for choice of 'weapon'
  local choice
  repeat
    os.execute("cls")  -- Windows specific command, change per OS
    print("\nRock, Paper, Scissors")
    print("=====================\n")
    print("Scores -\tPlayer:", score.player)
    print("\t\tCPU:", score.cpu .. "\n\t\tDraws:", score.draws)
    io.write("\nChoose [R]ock [P]aper or [S]cissors: ")
    choice = io.read():upper():sub(1, 1)
  until choice == "R" or choice == "P" or choice == "S"
  return choice
end

-- Decide who won, increment scores
function checkWinner (c, p)
  io.write("I chose ")
  if c == "R" then print("rock...") end
  if c == "P" then print("paper...") end
  if c == "S" then print("scissors...") end
  if c == p then
    print("\nDraw!")
    score.draws = score.draws + 1
  elseif  (c == "R" and p == "P") or
      (c == "P" and p == "S") or
      (c == "S" and p == "R") then
        print("\nYou win!")
        score.player = score.player + 1
  else
    print("\nYou lose!")
    score.cpu = score.cpu + 1
  end
end

-- Main procedure
math.randomseed(os.time())
score = {player = 0, cpu = 0, draws = 0}
record = {R = 0, P = 0, S = 0}
local playerChoice, cpuChoice
repeat
  cpuChoice = cpuMove()
  playerChoice = playerMove()
  record[playerChoice] = record[playerChoice] + 1
  checkWinner(cpuChoice, playerChoice)
  io.write("\nPress ENTER to continue or enter 'Q' to quit . . . ")
until io.read():upper():sub(1, 1) == "Q"
