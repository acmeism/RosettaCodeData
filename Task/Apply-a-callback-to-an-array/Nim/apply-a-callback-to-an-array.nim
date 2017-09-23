var arr = @[1,2,3,4]
arr.apply proc(some: var int) = echo(some, " squared = ", some*some)
