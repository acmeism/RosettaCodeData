let experiments = 1000000
var heads = 0
var wakenings = 0
for _ in (1...experiments) {
    wakenings += 1
    switch (Int.random(in: 0...1)) {
    case 0:
        heads += 1
    default:
        wakenings += 1
    }
}
print("Wakenings over \(experiments) experiments: \(wakenings)")
print("Sleeping Beauty should estimate a credence of: \(Double(heads) / Double(wakenings))")
