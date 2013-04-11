require'stats'
trmt=: 0.85 0.88 0.75 0.66 0.25 0.29 0.83 0.39 0.97
ctrl=: 0.68 0.41 0.1 0.49 0.16 0.65 0.32 0.92 0.28 0.98
difm=: -&mean
result=: trmt difm ctrl
all=: trmt(#@[ ({. difm }.) |:@([ (comb ~.@,"1 i.@])&# ,) { ,) ctrl
smoutput 'under: ','%',~":100*mean all <: result
smoutput 'over:  ','%',~":100*mean all > result
