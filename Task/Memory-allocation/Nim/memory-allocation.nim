# Allocate thread local heap memory
var a = alloc(1000)
dealloc(a)

# Allocate memory block on shared heap
var b = allocShared(1000)
deallocShared(b)
