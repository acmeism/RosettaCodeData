collectLevels =: >./\ <. >./\.                          NB. collect levels after filling
waterLevels=: collectLevels - ]                         NB. water levels for each tower
collectedWater=: +/@waterLevels                         NB. sum the units of water collected
printTowers =: ' ' , [: |.@|: '#~' #~ ] ,. waterLevels  NB. print a nice graph of towers and water
