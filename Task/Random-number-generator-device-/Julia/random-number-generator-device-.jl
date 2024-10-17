const rdev = "/dev/random"
rstream = try
    open(rdev, "r")
catch
    false
end

if isa(rstream, IOStream)
    b = readbytes(rstream, 4)
    close(rstream)
    i = reinterpret(Int32, b)[1]
    println("A hardware random number is:  ", i)
else
    println("The hardware random number stream, ", rdev, ", was unavailable.")
end
