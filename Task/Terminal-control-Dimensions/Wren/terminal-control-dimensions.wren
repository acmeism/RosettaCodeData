import "os" for Terminal

var size = Terminal.size
System.print("The dimensions of the terminal are:")
System.print("   Width  = %(size[1])")
System.print("   Height = %(size[0])")
