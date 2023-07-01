s <- sapply (1:10,
    function (x) {
        x  # force evaluation of promise x
	function () {
            R <- x*x
            # evaluate the language expression "x <- x + 1" in the persistent parent environment
            evalq (x <- x + 1, parent.env(environment()))
            R  # return squared value
    }})

s[[5]]()
[1] 25     # 5^2
s[[5]]()
[1] 36     # now 6^2
s[[1]]()
[1] 1      # 1^2
s[[1]]()
[1] 4      # now 2^2
