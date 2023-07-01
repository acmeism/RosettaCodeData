func openAuthenticationResponse(_password: String, operations: String) -> String? {
    var num1 = UInt32(0)
    var num2 = UInt32(0)
    var start = true
    let password = UInt32(_password)!
    for c in operations {
        if (c != "0") {
            if start {
                num2 = password
            }
            start = false
        }
        switch c {
        case "1":
            num1 = (num2 & 0xffffff80) >> 7
            num2 = num2 << 25
        case "2":
            num1 = (num2 & 0xfffffff0) >> 4
            num2 = num2 << 28
        case "3":
            num1 = (num2 & 0xfffffff8) >> 3
            num2 = num2 << 29
        case "4":
            num1 = num2 << 1
            num2 = num2 >> 31
        case "5":
            num1 = num1 << 5
            num2 = num2 >> 27
        case "6":
            num1 = num2 << 12
            num2 = num2 >> 20
        case "7":
            num1 = (num2 & 0x0000ff00) | ((num2 & 0x000000ff) << 24) | ((num2 & 0x00ff0000) >> 16)
            num2 = (num2 & 0xff000000) >> 8
        case "8":
            num1 = ((num2 & 0x0000ffff) << 16) | (num2 >> 24)
            num2 = (num2 & 0x00ff0000) >> 8
        case "9":
            num1 = ~num2
        case "0":
            num1 = num2
        default:
            print("unexpected char \(c)")
            return nil
        }
        if (c != "9") && (c != "0") {
            num1 |= num2
        }
        num2 = num1
    }
    return String(num1)
}
