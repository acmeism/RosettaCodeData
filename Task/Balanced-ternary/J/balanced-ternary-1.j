trigits=: 1+3 <.@^. 2 * 1&>.@|
trinOfN=: |.@((_1 + ] #: #.&1@] + [) #&3@trigits) :. nOfTrin
nOfTrin=: p.&3 :. trinOfN
trinOfStr=: 0 1 _1 {~ '0+-'&i.@|. :. strOfTrin
strOfTrin=: {&'0+-'@|. :. trinOfStr

carry=: +//.@:(trinOfN"0)^:_
trimLead0=: (}.~ i.&1@:~:&0)&.|.

add=: carry@(+/@,:)
neg=: -
mul=: trimLead0@carry@(+//.@(*/))
