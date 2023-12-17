woodSound = file.loadSound("small_wooden_bricks_movement.mp3")
puzzleTiles = function
	gfx.scale = 2
	woodImg = file.loadImage("/sys/pics/textures/Wood.png")
	
	gfx.drawImage woodImg,0,0
	gfx.color = color.black
	gfx.drawRect 6,6, 244,244
	
	bgBoard = new Sprite
	bgBoard.image = gfx.getImage(0, 0, 256, 256)
	bgBoard.scale = 1.6
	bgBoard.x = (960 - 1.6 * 256) / 2 + 128 * 1.6
	bgBoard.y = (640 - 1.6 * 256) / 2 + 128 * 1.6
	bgBoard.tint = color.rgb(102,51,0)
	sprites = [bgBoard]
	
	gfx.clear
	gfx.drawImage woodImg,0,0
	positions = range(1,15)
	positions.shuffle
	
	spriteScale = 1.5
	spriteSize = 64
	tileXOffset = (960 - 3 * spriteSize * spriteScale) / 2
	tileYOffset = (640 - 3 * spriteSize * spriteScale) / 2
	for i in range(0,14)
		s = str(i+1)
		pos = positions[i]
		x = pos % 4
		y = floor(pos / 4)
		xp = x * spriteSize + (spriteSize - (s.len * 14 + 2)) / 2
		yp = y * spriteSize + 20
		gfx.print s, xp, yp, color.black, "normal"
		
		sprite = new Sprite
		sprite.image = gfx.getImage(x * spriteSize, y * spriteSize, spriteSize, spriteSize)
		sprite.scale = spriteScale
		xs = i % 4; ys = 3 - floor(i / 4)
		sprite.x = spriteSize * (xs) * spriteScale + tileXOffset
		sprite.y = spriteSize * ys * spriteScale + tileYOffset
		sprite.localBounds = new Bounds
		sprite.localBounds.width = spriteSize
		sprite.localBounds.height = spriteSize
		
		// tint the blocks with different shades of brown
		sat = floor(rnd * 47 - 10) * 3
		sprite.tint = color.rgb(153 + sat, 102 + sat, 51 + sat)
		sprites.push(sprite)
	end for
	
	return sprites
end function

moveTiles = function(sprites, instructions, t = 6, mute = false)
	direction = instructions[0]
	delta = Directions[direction]
	if not mute and woodSound and direction then woodSound.play 0.1
	for i in range(96, 1, -t)
		for tile in instructions[1:]
			sprites[tile].x += delta[1] * t
			sprites[tile].y += -delta[0] * t
		end for
		wait 1/3200
	end for
end function
// These coordinates are [row,col] not [x,y]
Directions = {"up": [-1,0], "right": [0,1], "down": [1, 0], "left": [0,-1]}
TileNum = range(1, 15)
Puzzle15 = {"grid":[[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]],
"blankPos": [3,3], "movesToShuffled": [], "movesMade": [], "moveCount": 0}

Puzzle15.__setTile = function(position, value)
	row = position[0]; col = position[1]
	self.grid[row][col] = value
end function

Puzzle15.__getTile = function(position)
	row = position[0]; col = position[1]
	return self.grid[row][col]
end function

Puzzle15.__getOppositeDirection = function(direction)
	directions = Directions.indexes
	oppix = (directions.indexOf(direction) + 2) % 4
	return directions[oppix]
end function

Puzzle15.__getDirectionToTile = function(n)
	for row in range(0, 3)
		for col in range(0, 3)
			if self.grid[row][col] == n then
				dr = row - self.getBlankPos[0]
				dc = col - self.getBlankPos[1]
				return Directions.indexOf([sign(dr), sign(dc)])
			end if
		end for
	end for
	return null
end function

Puzzle15.getState = function
	return self.grid
end function

Puzzle15.getBlankPos = function
	return self.blankPos
end function

Puzzle15.hasWon = function
	count = 1
	for r in range(0, 3)
		for c in range(0, 3)
			if self.grid[r][c] != count then return false
			count += 1
		end for
	end for
	return true
end function

Puzzle15.move = function(direction)
	if not Directions.hasIndex(direction) then return false
	move = Directions[direction]
	curPos = self.blankPos[:]
	newPos = [curPos[0] + move[0], curPos[1] + move[1]]
	if (-1 < newPos[0] < 4) and (-1 < newPos[1] < 4) then
		value = self.__getTile(newPos)
		self.__setTile(curPos, value)
		self.__setTile(newPos, 16) // 16 is the blank tile
		self.blankPos = newPos
		if self.movesMade.len > 0 then
			lastMove = self.movesMade[-1]
		else
			lastMove = ""
		end if
		if lastMove != "" and self.__getOppositeDirection(lastMove) == direction then
			self.movesMade.pop
		else
			self.movesMade.push(direction)
		end if
		self.moveCount += 1
		return value // return tile that was moved
	else
		return false
	end if
end function

Puzzle15.moveNumber = function(n)
	direction = Puzzle15.__getDirectionToTile(n)
	origDir = direction
	
	if direction == null then return 0
	tiles = [self.__getOppositeDirection(direction)]
	while origDir == direction
		tileNum = self.move(origDir)
		tiles.insert(1, tileNum)
		direction = self.__getDirectionToTile(n)
	end while
	return tiles
end function

Puzzle15.shuffle = function(n, sprites)
	lastMove = ""
	directions = Directions.indexes
	cnt = 0
	instructions = []
	while self.movesToShuffled.len < n
		if self.movesToShuffled.len == 0 then
			lastMove = ""
		else
			lastMove = self.movesToShuffled[-1]
		end if
		moveTo = directions[floor(rnd * 4)]
		cnt += 1
		oppMove = self.__getOppositeDirection(moveTo)
		tileMoved = self.move(moveTo)
		
		if oppMove != lastMove and tileMoved then
			instructions.push([oppMove, tileMoved])
			lastMove = moveTo
			self.movesToShuffled.push(moveTo)
		else if oppMove == lastMove then
			self.movesToShuffled.pop
			instructions.pop
		end if
	end while
	for i in instructions
		moveTiles(sprites, i, 96, true)
	end for
end function

clear
display(4).sprites = puzzleTiles
gfx.clear
Puzzle15.shuffle(200, display(4).sprites)

while not Puzzle15.hasWon
	if mouse.button and not wasPressed then
		tile = 16
		for i in range(1, 15)
			sprite = display(4).sprites[i]
			//print sprite.localBounds
			if sprite.contains(mouse) then tile = i
			
		end for
		if tile != 16 then
			instructions = Puzzle15.moveNumber(tile)
			if instructions then moveTiles(display(4).sprites, instructions)
		end if
	end if
	wasPressed = mouse.button
	yield
end while
fanfare = file.loadSound("/sys/sounds/fanfare.wav")
fanfare.play 0.25
while fanfare.isPlaying
end while
key.get
