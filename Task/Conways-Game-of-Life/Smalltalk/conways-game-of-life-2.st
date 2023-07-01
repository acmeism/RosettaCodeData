Object subclass: #GameOfLife
  instanceVariableNames: 'aliveCells boardSize'
  classVariableNames: ''
  poolDictionaries: ''
  category: 'GameOfLife'

GameOfLife class>>withAliveCells: aCollectionOfCells ofSize: aBoardSize
  self assertAll: aCollectionOfCells areInside: aBoardSize.
  ^self new initializeWithAliveCells: aCollectionOfCells ofSize: aBoardSize

GameOfLife class>>assertAll: aCollectionOfAliveCells areInside: aSize
  | origin |	
  origin := 0@0.
  aCollectionOfAliveCells do: [:aCell |
  (aCell between: origin and: aSize) ifFalse: [ self error: 'Cell ', aCell printString,' out of range' ]]

initializeWithAliveCells: aCollectionOfCells ofSize: aBoardSize
  aliveCells := aCollectionOfCells asSet.
  boardSize := aBoardSize

calculateNextGeneration
  aliveCells := self boardCellsSelect: [ :aCell | self shouldBeAliveOnNextGeneration: aCell ]

shouldBeAliveOnNextGeneration: aCell
  | numberOfAliveNeighbors |
  numberOfAliveNeighbors := self numberOfAliveNeighborsOf: aCell.
  ^numberOfAliveNeighbors = 3 or: [ self shouldSurvive: aCell with: numberOfAliveNeighbors]

shouldSurvive: aCell with: numberOfAliveNeighbors
  ^ (self isAlive: aCell) and: [ numberOfAliveNeighbors = 2 ]

isAlive: aCell
  ^aliveCells includes: aCell

isDead: aCell
  ^(self isAlive: aCell) not

boardCellsDo: aClosure
  0 to: boardSize x do: [ :x |
    0 to: boardSize y do: [ :y | aClosure value: x@y ]]

boardCellsSelect: aCondition
  | selectedCells |
  selectedCells := Set new.
  self boardCellsDo: [ :aCell | (aCondition value: aCell)  ifTrue: [ selectedCells add: aCell ]].
  ^selectedCells

numberOfAliveNeighborsOf: aCell
  ^aCell eightNeighbors count: [ :aNeighbor | self isAlive: aNeighbor ]
