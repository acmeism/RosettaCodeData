"this simple implementation of a bidimensional array
 lacks controls over the indexes, but has a way of iterating
 over array's elements, from left to right and top to bottom"
Object subclass: BiArray [
  |cols rows elements|
  BiArray class >> columns: columns  rows: howManyRows [
      ^ super basicNew init: columns per: howManyRows
  ]
  init: columns per: howManyRows [
     cols := columns.
     rows := howManyRows.
     elements := Array new: ( columns * howManyRows )
  ]
  calcIndex: biIndex [ "column, row (x,y) to linear"
    ^ ( (biIndex at: 1) + (((biIndex at: 2) - 1) * cols) )
  ]
  at: biIndex [ "biIndex is an indexable containing column row"
     ^ elements at: (self calcIndex: biIndex).
  ]
  directAt: i [ ^ elements at: i ]
  at: biIndex put: anObject [
     elements at: (self calcIndex: biIndex) put: anObject
  ]
  whileTrue: aBlock do: anotherBlock [
     |i lim|
     i := 1. lim := rows * cols.
     [ ( i <= lim )
         & (aBlock value: (self directAt: i) )
     ] whileTrue: [
         anotherBlock value: (self directAt: i).
         i := i + 1.
       ]
  ]
].

|biarr|
biarr := BiArray columns: 10 rows: 10.

"fill the array; this illustrates nested loop but not how to
 escape from them"
1 to: 10 do: [ :c |
  1 to: 10 do: [ :r |
     biarr at: {c . r} put: (Random between: 1 and: 20)
  ]
].

"loop searching for 20; each block gets the element passed as argument"
biarr whileTrue: [ :v | v ~= 20 ]
      do: [ :v | v displayNl ]
