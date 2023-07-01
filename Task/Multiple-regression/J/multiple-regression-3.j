   mp=: +/ .*                    NB. matrix product
                                 NB. %.X is matrix inverse of X
                                 NB. |:X is transpose of X

   (%.(|:X) mp X) mp (|:X) mp y
128.814 _143.163 61.9606
   xpy=: mp~ |:                  NB. Or factoring out "X prime y" (monadically "X prime X")
   X (%.@:xpy@[ mp xpy) y
128.814 _143.163 61.9606
