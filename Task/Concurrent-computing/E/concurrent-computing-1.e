def base := timer.now()
for string in ["Enjoy", "Rosetta", "Code"] {
    timer <- whenPast(base + entropy.nextInt(1000), fn { println(string) })
}
