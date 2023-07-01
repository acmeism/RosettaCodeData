: test
| sma3 sma5 l |
   3 createSMA -> sma3
   5 createSMA -> sma5
   [ 1, 2, 3, 4, 5, 5, 4, 3, 2, 1 ] ->l
   "SMA3" .cr l apply( #[ sma3 perform . ] ) printcr
   "SMA5" .cr l apply( #[ sma5 perform . ] ) ;
