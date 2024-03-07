/* Terminal_control_Dimensions.wren */

class C {
    foreign static terminalWidth
    foreign static terminalHeight
}

var w = C.terminalWidth
var h = C.terminalHeight
System.print("The dimensions of the terminal are:")
System.print("   Width  = %(w)")
System.print("   Height = %(h)")
