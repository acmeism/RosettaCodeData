import "/ioutil" for FileUtil

var fileName = "temp.txt"

// create a file of length 26 bytes
FileUtil.write(fileName, "abcdefghijklmnopqrstuvwxyz")
System.print("Contents before truncation: %(FileUtil.read(fileName))")

// truncate file to 13 bytes
FileUtil.truncate(fileName, 13)
System.print("Contents after truncation : %(FileUtil.read(fileName))")

// attempt to truncate file to 20 bytes
FileUtil.truncate(fileName, 20)
System.print("Contents are still        : %(FileUtil.read(fileName))")
