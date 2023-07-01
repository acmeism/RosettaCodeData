var func = Fn.new {
    for (i in 1..10) {
        if (i == 1) continue // jumps to next iteration when 'i' equals 1
        System.print("i = %(i)")
        if (i > 4) break     // exits the loop when 'i' exceeds 4
    }
    for (j in 1..10) {
        System.print("j = %(j)")
        if (j == 3) return   // returns from the function when 'j' exceeds 3
    }
}

var fiber = Fiber.new {
    System.print("starting")
    Fiber.yield()            // yields control back to the calling fiber
    System.print("resuming") // resumes here when called again
    Fiber.abort("aborting")  // aborts the script
}

func.call()                  // calls the function
fiber.call()                 // calls the fiber
System.print("yielding")
fiber.call()                 // resumes the fiber
return                       // would exit the module (and script) without error but won't be reached
