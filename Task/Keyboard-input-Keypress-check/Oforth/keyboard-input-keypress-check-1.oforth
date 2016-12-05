import: console

: checkKey
| key |
   System.Console receiveTimeout(2000000) ->key   // Wait a key pressed for 2 seconds
   key ifNotNull: [ System.Out "Key pressed : " << key << cr ]
   "Done" println ;
