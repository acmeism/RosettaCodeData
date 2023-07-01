gamewon = false
running_total = 0
player = 1
opponent = 2

while not gamewon do
  num = 0

  if player == 1 then
    opponent = 2
    repeat
      print("Enter a number between 1 and 3 (0 to quit):")
      num = io.read("*n")
      if num == 0 then
          os.exit()
      end
    until (num > 0) and (num <=3)
  end

  if player == 2 and not (gamewon) then
      opponent = 1
      if (21 - running_total <= 3) then
        num = 21 - running_total
      else
        num = math.random(1,3)
      end
      print("Player 2 picks number "..num)
  end

  running_total = running_total + num
  print("Total: "..running_total)

  if running_total == 21 then
    print("Player "..player.." wins!")
    gamewon = true
  end

  if running_total > 21 then
    print("Player "..player.." lost...")
    print("Player "..opponent.." wins!")
    gamewon = true
  end

  if player == 1 then
    player = 2
  else player = 1
  end

end
