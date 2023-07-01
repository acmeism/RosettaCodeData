def sequence = "1"
(1..12).each {
    println sequence
    sequence = lookAndSay(sequence)
}
