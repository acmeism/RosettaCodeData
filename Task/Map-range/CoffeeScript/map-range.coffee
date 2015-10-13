mapRange = (a1,a2,b1,b2,s) ->
    t = b1 + ((s-a1)*(b2 - b1)/(a2-a1))

for s in [0..10]
    console.log("#{s} maps to #{mapRange(0,10,-1,0,s)}")
