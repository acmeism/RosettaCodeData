"The selector swap:with: is documented, but it seems not
 implemented (GNU Smalltalk version 3.0.4); so here it is an implementation"
SequenceableCollection extend [
  swap: i with: j [
    |t|
    t := self at: i.
    self at: i put: (self at: j).
    self at: j put: t.
  ]
].

Object subclass: Shuffler [
  Shuffler class >> Knuth: aSequenceableCollection [
    |n k|
    n := aSequenceableCollection size.
    [ n > 1 ] whileTrue: [
      k := Random between: 1 and: n.
      aSequenceableCollection swap: n with: k.
      n := n - 1
    ]
  ]
].
