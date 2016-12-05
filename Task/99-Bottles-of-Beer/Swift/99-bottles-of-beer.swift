for i in reverse(1...99) {

    println("\(i) bottles of beer on the wall, \(i) bottles of beer.")
    let next = i == 1 ? "no" : i.description
    println("Take one down and pass it around, \(next) bottles of beer on the wall.")
}
