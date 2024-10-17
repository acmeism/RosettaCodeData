'`X Y L H M'=. ,{{y&{::`''}}&>i.5      NB. Setting mnemonics for boxes (e.g. X=.0&{::)
'l h m'     =. 2 3 4                   NB. more box mnemonics (used for e.g. m})

boxes   =. ;,a:$~3:                    NB. Appending 3 (empty) boxes to the inputs
LowHigh =. (0;#@X) (l,h)} ]            NB. Setting the low and high bounds
midpoint=. <@(<.@(2%~L+H)) m} ]        NB. Updating the midpoint
case    =. >:@:*@(Y-M{X)               NB. Less=0, equal=1, or greater=2

squeeze =. (<@(_1+M) h} ])`(<@_ l} ])`(<@(1+M) l} ])@.case
return  =. [: M (<@'Not Found' m} ])^:(_~:L)
bs      =. return@(squeeze@midpoint^:(L<:H)^:_)@LowHigh@boxes
