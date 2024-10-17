function inputlines(txtfile, iochannel)
    for line in readlines(txtfile)
        Base.put!(iochannel, line)
    end
    Base.put!(iochannel, nothing)
    println("The other task printed $(take!(iochannel)) lines.")
end

function outputlines(iochannel)
    totallines = 0
    while (line = Base.take!(iochannel)) != nothing
        totallines += 1
        println(line)
    end
    Base.put!(iochannel, totallines)
end

c = Channel(0)
@async inputlines("filename.txt", c)
outputlines(c)
