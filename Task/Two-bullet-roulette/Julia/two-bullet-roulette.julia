const cyl = zeros(Bool, 6)

function load()
    while cyl[1]
        cyl .= circshift(cyl, 1)
    end
    cyl[1] = true
    cyl .= circshift(cyl, 1)
end

spin() = (cyl .= circshift(cyl, rand(1:6)))

fire() = (shot = cyl[1]; cyl .= circshift(cyl, 1); shot)

function LSLSFSF()
    cyl .= 0
    load(); spin(); load(); spin()
    fire() && return true
    spin(); return fire()
end

function LSLSFF()
    cyl .= 0
    load(); spin(); load(); spin()
    fire() && return true
    return fire()
end

function LLSFSF()
    cyl .= 0
    load(); load(); spin()
    fire() && return true
    spin(); return fire()
end

function LLSFF()
    cyl .= 0
    load(); load(); spin()
    fire() && return true
    return fire()
end

function testmethods(N = 10000000)
    for (name, method) in [("load, spin, load, spin, fire, spin, fire", LSLSFSF),
                           ("load, spin, load, spin, fire, fire", LSLSFF),
                           ("load, load, spin, fire, spin, fire", LLSFSF),
                           ("load, load, spin, fire, fire", LLSFF)]
        percentage = 100 * sum([method() for _ in 1:N]) / N
        println("Method $name produces $percentage per cent deaths.")
    end
end

testmethods()
