extension Complex : CustomStringConvertible {

    public var description : String {

        guard real != 0 || imaginary != 0 else { return "0" }

        let rs : String = real != 0 ? "\(real)" : ""
        let iS : String
        let sign : String
        let iSpace = real != 0 ? " " : ""
        switch imaginary {
        case let i where i < 0:
            sign = "-"
            iS = i == -1 ? "i" : "\(-i)i"
        case let i where i > 0:
            sign = real != 0 ? "+" : ""
            iS = i == 1 ? "i" : "\(i)i"
        default:
            sign = ""
            iS = ""
        }
        return "\(rs)\(iSpace)\(sign)\(iSpace)\(iS)"
    }
}
