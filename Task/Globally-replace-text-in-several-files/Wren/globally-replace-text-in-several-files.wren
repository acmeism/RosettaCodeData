import "io" for File

var files = ["file1.txt", "file2.txt"]
for (file in files) {
    var text = File.read(file)
    System.print("%(file) contains: %(text)")
    text = text.replace("Goodbye London!", "Hello New York!")
    File.create(file) { |f|  // overwrites existing file
        f.writeBytes(text)
    }
    System.print("%(file) now contains: %(File.read(file))")
}
