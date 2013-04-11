require 'types/datetime'
parseTimes=: ([: _&".;._2 ,&':');._2
secsFromTime=:  24 60 60 #. ]     NB. convert from time to seconds
rft=: 2r86400p1 * secsFromTime    NB. convert from time to radians
meanTime=: 'hh:mm:ss' fmtTime [: secsFromTime [: avgAngleR&.rft parseTimes
