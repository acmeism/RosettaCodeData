print("\033[?1049h\033[H")
println("Alternate buffer!")

for (i <- 5 to 0 by -1) {
    println(s"Going back in: $i")
    Thread.sleep(1000)
}

print("\033[?1049l")
