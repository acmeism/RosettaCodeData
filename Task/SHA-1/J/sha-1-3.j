   text2bits=: (8#2) ,@:#: a. i. ]
   bits2hex=: '0123456789abcdef' {~ _4 #.\ ,

   bits2hex sha1 text2bits 'Rosetta Code'
48c98f7e5a6e736d790ab740dfc3f51a61abe2b5
