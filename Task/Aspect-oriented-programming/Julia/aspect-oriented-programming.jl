module Adder
    exports add2

    function add2(x)
        return x + 2
    end
end

module LogAspectAdder
    exports add2
    using Adder
    const logio = [stdout]

    function log(s, io=logio[1])
        println(io, now(), " ", s)
    end

    function add2(x)
        log("added 2 to $x")
        Adder.add2(x)
    end
end
