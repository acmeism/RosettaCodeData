struct IAmaSingleton end

x = IAmaSingleton()
y = IAmaSingleton()

println("x == y is $(x == y) and x === y is $(x === y).")
