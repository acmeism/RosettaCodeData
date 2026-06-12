Integer extend [
  millerRabinTest: kl [ |k| k := kl.
    self <= 3
      ifTrue: [ ^true ]
      ifFalse: [
         (self even)
           ifTrue: [ ^false ]
           ifFalse: [ |d s|
              d := self - 1.
              s := 0.
              [ (d rem: 2) == 0 ]
                 whileTrue: [
                   d := d / 2.
                   s := s + 1.
                 ].
              [ k:=k-1. k >= 0 ]
                 whileTrue: [ |a x r|
                    a := Random between: 2 and: (self - 2).
                    x := (a raisedTo: d) rem: self.
                    ( x = 1 )
                      ifFalse: [ |r|
		        r := -1.
                          [ r := r + 1. (r < s) & (x ~= (self - 1)) ]
                          whileTrue: [
                     	    x := (x raisedTo: 2) rem: self
                          ].
                        ( x ~= (self - 1) ) ifTrue: [ ^false ]
                      ]
                 ].
              ^true
           ]
      ]
  ]
].
