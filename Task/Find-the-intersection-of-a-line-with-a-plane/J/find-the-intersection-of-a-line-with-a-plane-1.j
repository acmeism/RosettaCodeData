mp=: +/ .*                          NB. matrix product
p=: mp&{: %~ -~&{. mp {:@]          NB. solve
intersectLinePlane=: [ +/@:* 1 , p  NB. substitute
