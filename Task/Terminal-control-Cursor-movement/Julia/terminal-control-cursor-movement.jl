const ESC = "\u001B" # escape code
const moves = Dict( "left" => "[1D", "right" => "[1C", "up" => "[1A", "down" => "[1B",
                    "linestart" => "[9D", "topleft" => "[H", "bottomright" => "[24;79H")

print("$ESC[2J")     # clear terminal first
print("$ESC[10;10H") # move cursor to (10, 10) say
const count = [0]
for d in ["left", "right", "up", "down", "linestart", "bottomright"]
    sleep(3) # three second pause for display between cursor movements
    print("$ESC$(moves[d])")
    print(count[1] += 1)
end
println()
println()
