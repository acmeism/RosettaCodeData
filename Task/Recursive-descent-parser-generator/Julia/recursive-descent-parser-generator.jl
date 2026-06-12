const one, two, three, four, five, six, seven, eight, nine = collect(1:9)

function testparser(s)
    cod = Meta.parse(s)
    println(Meta.lower(Main, cod))
end

testparser("(one + two) * three - four * five")
