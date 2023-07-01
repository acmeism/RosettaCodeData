import "os" for Platform
import "io" for File

var fileName = (Platform.isWindows) ? "TAPE.FILE" : "/dev/tape"
File.create(fileName) { |file|
    file.writeBytes("Hello World!\n")
}
