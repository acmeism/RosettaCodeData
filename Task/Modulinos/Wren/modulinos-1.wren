/* Modulinos.wren */

var MeaningOfLife = Fn.new { 42 }

var main = Fn.new {
    System.print("The meaning of life is %(MeaningOfLife.call()).")
}

// Check if it's being used as a library or not.
import "os" for Process
if (Process.allArguments[1] == "Modulinos.wren") {  // if true, not a library
    main.call()
}
