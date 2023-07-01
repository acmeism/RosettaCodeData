pool = {} -- create an "arena" for the variables a,b,c,d
pool.a = 1 -- individually allocated..
pool.b = "hello"
pool.c = true
pool.d = { 1,2,3 }
pool = nil -- release reference allowing garbage collection of entire structure
