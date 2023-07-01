TestCase subclass: #GameOfLifeTest
  instanceVariableNames: ''
  classVariableNames: ''
  poolDictionaries: ''
  category: 'GameOfLife'

test01AliveCellWithLessThatTwoAliveCellsDies
  | gameOfLife |
  gameOfLife := GameOfLife withAliveCells: {1@1} ofSize: 3@3.
  gameOfLife calculateNextGeneration.
  self assert: (gameOfLife isDead: 1@1)

test02AliveCellWithTwoAliveNeighborsSurvives
  | gameOfLife |
  gameOfLife := GameOfLife withAliveCells: {1@1. 1@2. 2@1} ofSize: 3@3.
  gameOfLife calculateNextGeneration.
  self assert: (gameOfLife isAlive: 1@1).

test03AliveCellWithThreeAliveNeighborsSurvives
  | gameOfLife |
  gameOfLife := GameOfLife withAliveCells: {1@1. 1@2. 2@1. 2@2} ofSize: 3@3.
  gameOfLife calculateNextGeneration.
  self assert: (gameOfLife isAlive: 1@1).

test04DeadCellWithThreeAliveNeighborsBecomesAlive
  | gameOfLife |
  gameOfLife := GameOfLife withAliveCells: {1@1. 1@2. 2@1} ofSize: 3@3.
  gameOfLife calculateNextGeneration.
  self assert: (gameOfLife isAlive: 2@2).

test05DeadCellWithAliveNeighborsDifferentToThreeKeepsDead
  | gameOfLife |
  gameOfLife := GameOfLife withAliveCells: {1@2. 2@2. 3@2. 1@3} ofSize: 3@3.
  gameOfLife calculateNextGeneration.
  self assert: (gameOfLife isDead: 1@1).
  self assert: (gameOfLife isDead: 2@3).

test06CanNotCreateGameWithCellOutsideXOrigin
  self
    should: [ GameOfLife withAliveCells: { 2@0. 1@0. -1@1 } ofSize: 3@3 ]
    raise: Error - MessageNotUnderstood
    withMessageText: 'Cell -1@1 out of range'

test07CanNotCreateGameWithCellOutsideYOrigin
  self
    should: [ GameOfLife withAliveCells: { 2@0. 1@0. 1@-1 } ofSize: 3@3 ]
    raise: Error - MessageNotUnderstood
    withMessageText: 'Cell 1@-1 out of range'

test08CanNotCreateGameWithCellOutsideXLimit
  self
    should: [ GameOfLife withAliveCells: { 2@0. 1@0. 4@1 } ofSize: 3@3 ]
    raise: Error - MessageNotUnderstood
    withMessageText: 'Cell 4@1 out of range'

test09CanNotCreateGameWithCellOutsideYLimit
  self
    should: [ GameOfLife withAliveCells: { 2@0. 1@0. 1@4 } ofSize: 3@3 ]
    raise: Error - MessageNotUnderstood
    withMessageText: 'Cell 1@4 out of range'
