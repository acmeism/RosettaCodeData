'`X Y L H M'=. ,{{y&{::`''}}&>i.5      NB. Setting mnemonics for boxes (e.g. X=.0&{::)
'l h m'     =. 2 3 4                   NB. more box mnemonics (used for e.g. m})

boxes   =. a:,~;                       NB. Appending 3 (empty) boxes to the inputs
LowHigh =. (0;#@X) (l,h)} ]            NB. Setting the low and high bounds
midpoint=. <@(<.@(2%~L+H)) m} ]        NB. Updating the midpoint
case    =. >:@:*@(Y-M{X)               NB. Less=0, equal=1, or greater=2

recur   =. (X bs Y;L;(_1+M))`M`(X bs Y;(1+M);H)@.case
bs      =. recur@midpoint`('Not Found'"_)@.(H<L)@boxes :: ([ bs ]; 0; <:@#@[)
