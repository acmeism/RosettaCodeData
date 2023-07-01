-0                                #=> -0
0 == -0                           # => true
infinite == infinite              #=> true
infinite == -(-infinite)          #=> true
(infinite + infinite) == infinite #=> true
1/infinite                        #=> 0

nan == nan                        #=> false # N.B.
