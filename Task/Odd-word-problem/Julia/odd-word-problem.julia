# io = readstring(STDIN)
io = "what,is,the;meaning,of:life."
i  = 0

readbyte!() = io[global i += 1]
writebyte(c) = print(Char(c))

function odd(prev::Function = () -> false)
    a = readbyte!()
    if !isalpha(a)
        prev()
        writebyte(a)
        return a != '.'
    end

    # delay action until later, in the shape of a closure
    clos() = (writebyte(a); prev())

    return odd(clos)
end

function even()
    while true
        c = readbyte!()
        writebyte(c)
        if !isalpha(c) return c != '.' end
    end
end

evn = false
while evn ? odd() : even()
    evn = !evn
end
