step =: -.&' '&.":@q:
hseq =: [,$:@step`(0&$)@.(1&p:)
fmtHP =: (' is prime',~":@])`('HP',":@],'(',":@[,')'&[)@.(*@[)
fmtlist =: [:;@}.[:,(<' = ')&,"0@(|.@i.@# fmtHP each [)
printHP =: 0 0&$@stdout@(fmtlist@hseq,(10{a.)&[)
printHP"0 [ 2}.i.21
exit 0
