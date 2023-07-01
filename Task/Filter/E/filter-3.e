def makeSeries := <elang:control.makeSeries>
makeSeries([1,2,3,4,5,6,7,8,9,10]).filter(fn x,_{x %% 2 <=> 0}).asList()
