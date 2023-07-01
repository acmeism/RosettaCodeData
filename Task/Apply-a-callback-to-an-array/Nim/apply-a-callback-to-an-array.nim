from std/sequtils import apply
let arr = @[1,2,3,4]
arr.apply proc(some: int) = echo(some, " squared = ", some*some)
