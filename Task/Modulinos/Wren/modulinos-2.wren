/* Modulinos_main.wren */

import "./Modulinos" for MeaningOfLife

var main = Fn.new {
    System.print("Who says the meaning of life is %(MeaningOfLife.call())?")
}

main.call()
