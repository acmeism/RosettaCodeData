ImageMorph subclass: #GameOfLifeView
  instanceVariableNames: 'game'
  classVariableNames: ''
  poolDictionaries: ''
  category: 'GameOfLife'

GameOfLifeView class>>for: aGameOfLife
  ^self new initializeFor: aGameOfLife

GameOfLifeView class>>openFor: aGameOfLife
  ^(self for: aGameOfLife) open

GameOfLifeView class>>blinker
  ^GameOfLife withAliveCells: { 4@2. 4@3. 4@4. 3@3. 4@3. 5@3 } ofSize: 10@10
  	
GameOfLifeView class>>toad
  ^GameOfLife withAliveCells: { 2@4. 3@4. 4@4. 3@3. 4@3. 5@3 } ofSize: 10@10

GameOfLifeView class>>openBlinker
  ^self openFor: self blinker

GameOfLifeView class>>openToad
  ^self openFor: self toad  	

initializeFor: aGameOfLife
  game := aGameOfLife.
  self image: (Form extent: game boardSize * 5 depth: 2).

open
  self showBoard.
  self openInWorld.
  self startSteppingStepTime: 500

showBoard
  game boardCellsDo: [ :aPoint |
    (game isAlive: aPoint)
      ifTrue: [ self form fillBlack: (aPoint*5 extent: 5@5) ]
      ifFalse: [ self form fillWhite: (aPoint*5 extent: 5@5) ]].

step
  game calculateNextGeneration.
  self showBoard.
  self redrawNeeded.
