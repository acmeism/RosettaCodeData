set(x 42)
set(y "string")
swap(x y)
message(STATUS ${x})  # -- string
message(STATUS ${y})  # -- 42
