dice5() = rand(1:5)

function dice7()
    r = 5*dice5() + dice5() - 6
    r < 21 ? (r%7 + 1) : dice7()
end
