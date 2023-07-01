Smalltalk at: #gnomesort put: nil.

"Utility"
OrderedCollection extend [
  swap: a with: b [ |t|
      t := self at: a.
      self at: a put: b.
      self at: b put: t
  ]
].

"Gnome sort as block closure"
gnomesort := [ :c |
  |i j|
  i := 2. j := 3.
  [ i <= (c size) ]
    whileTrue: [
       (c at: (i-1)) <= (c at: i)
          ifTrue: [
             i := j copy.
             j := j + 1.
          ]
          ifFalse: [
             c swap: (i-1) with: i.
             i := i - 1.
             i == 1
               ifTrue: [
                  i := j copy.
                  j := j + 1
               ]
          ]
    ]
].
