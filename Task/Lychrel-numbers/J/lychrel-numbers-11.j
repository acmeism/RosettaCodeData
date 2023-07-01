   revdig=:('x',~|.)&.":"0
   lychrel500=: (~: revdig)@((+^:~: revdig)^:500)@(+revdig)"0
   L=:I.lychrel500 i.10001
   S=:(+revdig)^:(i.501)"0 L
   owned=: <@~.@,\S
   #T=: (-. (<"1 S) +./@e.&> a:,}:owned)#L
5
   T
196 879 1997 7059 9999
   L -&# T
244
   (#~(=revdig))L
4994 8778 9999
