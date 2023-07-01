func addSuffix(n:Int) -> String {
    if n % 100 / 10 == 1 {
        return "th"
    }

    switch n % 10 {
    case 1:
        return "st"
    case 2:
        return "nd"
    case 3:
        return "rd"
    default:
        return "th"
    }
}

for i in 0...25 {
    print("\(i)\(addSuffix(i)) ")
}
println()
for i in 250...265 {
    print("\(i)\(addSuffix(i)) ")
}
println()
for i in 1000...1025 {
    print("\(i)\(addSuffix(i)) ")
}
println()
