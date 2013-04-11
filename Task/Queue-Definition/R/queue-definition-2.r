# The usual Scheme way : build a function that takes commands as parameters (it's like message passing oriented programming)
queue <- function() {
	v <- list()
	f <- function(cmd, val=NULL) {
		if(cmd == "push") {
			v <<- c(v, val)
			invisible()
		} else if(cmd == "pop") {
			if(length(v) == 0) {
				stop("empty queue")
			} else {
				x <- v[[1]]
				v[[1]] <<- NULL
				x
			}
		} else if(cmd == "length") {
			length(v)
		} else if(cmd == "empty") {
			length(v) == 0
		} else {
			stop("unknown command")
		}
	}
	f
}

# Create two queues
a <- queue()
b <- queue()
a("push", 1)
a("push", 2)
b("push", 3)
a("push", 4)
b("push", 5)

a("pop")
# [1] 1
b("pop")
# [1] 3
