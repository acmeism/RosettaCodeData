function isbncheck(str)
    return sum(iseven(i) ? 3 * parse(Int, ch) : parse(Int, ch)
        for (i, ch) in enumerate(replace(str, r"\D" => ""))) % 10 == 0
end

const testingcodes = ["978-0596528126", "978-0596528120",
                      "978-1788399081", "978-1788399083"]

for code in testingcodes
    println(code, ": ", isbncheck(code) ? "good" : "bad")
end
