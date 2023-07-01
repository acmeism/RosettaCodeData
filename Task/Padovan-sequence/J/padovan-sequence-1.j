padovanSeq=: (],+/@(_2 _3{]))^:([-3:)&1 1 1

NB. or, equivalently:
padovanSeq=: (, [: +/ _2 {. }:)@]^:([ - 2:)&1 1

realRoot=. {:@(#~ ]=|)@;@p.
padovanNth=: 0.5 <.@+ (realRoot _23 23 _2 1) %~ (realRoot _1 _1 0 1)^<:

padovanL=: rplc&('A';'B'; 'B';'C'; 'C';'AB')@]^:[&'A'
seqLen=. #@(-.&' ')"1
