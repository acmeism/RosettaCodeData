import "io" for File, FileFlags

var specialFile = "wren-exclusive._sp"
var checkOneInstanceRunning = Fn.new {
    // attempt to create the special file with exclusive access
    var ff = FileFlags.create | FileFlags.exclusive
    File.openWithFlags(specialFile, ff) { |file| }  // closes automatically if successful
}

// check if the current instance is the only one running
var fiber = Fiber.new {
    checkOneInstanceRunning.call()
}
var error = fiber.try()
if (error) {
    System.print("An instance is already running.")
    return
}

// do something that takes a while for testing purposes
var sum = 0
for (i in 1...1e8) {
   sum = sum + i
}
System.print(sum)

File.delete(specialFile) // clean up
