asString=: ":"0                NB. convert vals to strings
getPfxSize=: [: -:@| 3 -~ #    NB. get size of prefix to drop before the 3 middle digits
getMid3=: (3 {. getPfxSize }. ,&'err') :: ('err'"_)  NB. get 3 middle digits or return 'err'
getMiddle3=: getMid3@asString@:|
