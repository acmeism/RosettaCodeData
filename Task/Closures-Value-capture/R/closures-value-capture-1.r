# assign 's' a list of ten functions
s <- sapply (1:10,  # integers 1..10 become argument 'x' below
    function (x) {
        x  # force evaluation of promise x
	function (i=x) i*i   # this *function* is the return value
    })

s[[5]]()  # call the fifth function in the list of returned functions
[1] 25    # returns vector of length 1 with the value 25
