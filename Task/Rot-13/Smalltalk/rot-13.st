"1. simple approach"
rot13 := [ :string |
  string collect: [ :each | | index |
    index := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
      indexOf: each ifAbsent: [ 0 ]. "Smalltalk uses 1-based indexing"
        index isZero
          ifTrue: [ each ]
          ifFalse: [ 'nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM' at:
            index ] ] ].

(rot13 value: 'Test123') printNl "gives 'Grfg123'"

"2. extending built-in classes"
Character extend [
  + inc [
     (inc isKindOf: Character)
     ifTrue: [
        ^ ( Character value: ((self asInteger) + (inc asInteger)) )
     ] ifFalse: [
       ^ ( Character value: ((self asInteger) + inc) )
     ]
  ]
  - inc [
    ^ ( self + (inc asInteger negated) )
  ]
  trFrom: map1 to: map2 [
     (map1 includes: self) ifTrue: [
        ^ map2 at: (map1 indexOf: self)
     ] ifFalse: [ ^self ]
  ]
].

String extend [
  rot: num [ |s|
    s := String new.
    self do: [ :c |
         ((c asLowercase) between: $a and: $z)
	   ifTrue: [ |c1|
              c1 := ( $a + ((((c asLowercase) - $a + num) asInteger) rem:26)).
              (c isLowercase) ifFalse: [ c1 := c1 asUppercase ].
              s := s, (c1 asString)
           ]
           ifFalse: [
	      s := s, (c asString)
           ]
     ].
     ^s
  ]
].

('abcdefghijklmnopqrstuvwxyz123!' rot: 13) displayNl.
(('abcdefghijklmnopqrstuvwxyz123!' rot: 13) rot: 13) displayNl.



"2. using a 'translation'. Not very idiomatic Smalltalk code"
rotThirteen := [ :s | |m1 m2 r|
  r := String new.
  m1 := OrderedCollection new.
  0 to: 25 do: [ :i | m1 add: ($a + i) ].
  m2 := OrderedCollection new.
  0 to: 25 do: [ :i | m2 add: ($a + ((i+13) rem: 26)) ].
  s do: [ :c |
    (c between: $a and: $z) | (c between: $A and: $Z)
      ifTrue: [ | a |
        a := (c asLowercase) trFrom: m1 to: m2.
        (c isUppercase) ifTrue: [ a := a asUppercase ].
        r := r, (a asString)]
      ifFalse: [ r := r, (c asString) ]
  ].
  r
].

(rotThirteen value: 'abcdefghijklmnopqrstuvwxyz123!') displayNl.
