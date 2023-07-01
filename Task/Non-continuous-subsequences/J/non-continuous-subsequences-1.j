allmasks=: 2 #:@i.@^ #
firstend=:1 0 i.&1@E."1 ]
laststart=: 0 1 {:@I.@E."1 ]
noncont=: <@#~ (#~ firstend < laststart)@allmasks
