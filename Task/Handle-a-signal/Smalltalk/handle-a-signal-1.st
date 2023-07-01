|n|

n := 0.
UserInterrupt
     catch:[
         [true] whileTrue:[
             n := n + 1.
             n printCR.
             Delay waitForSeconds: 0.5.
         ]
     ]
