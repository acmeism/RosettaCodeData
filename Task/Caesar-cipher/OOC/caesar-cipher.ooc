main: func (args: String[]) {
        shift := args[1] toInt()
        if (args length != 3) {
                "Usage: #{args[0]} [number] [sentence]" println()
                "Incorrect number of arguments." println()
        } else if (!shift && args[1] != "0"){
                "Usage: #{args[0]} [number] [sentence]" println()
                "Number is not a valid number." println()
        } else {
                str := ""
                for (c in args[2]) {
                        if (c alpha?()) {
                                c = (c lower?() ? 'a' : 'A') + (26 + c toLower() - 'a' + shift) % 26
                        }
                        str += c
                }
                str println()
        }
}
