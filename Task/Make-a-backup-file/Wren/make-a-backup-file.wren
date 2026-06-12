import "./ioutil" for File, FileUtil

var saveWithBackup = Fn.new { |filePath, lines|
    var origPath = filePath
    if (File.exists(origPath)) {
        origPath = File.realPath(origPath)  // gets the canonical absolute path to the file
        var backupPath = origPath + ".backup"
        FileUtil.move(origPath, backupPath) // follows Linux convention of moving rather than renaming
    }
    FileUtil.writeLines(origPath, lines)    // overwrites the file if it already exists
}

saveWithBackup.call("original.txt", ["fourth", "fifth", "sixth"])

// check it worked
System.print("Current contents of original.txt:")
System.print(File.read("original.txt"))
System.print("Contents of original.txt.backup:")
System.print(File.read("original.txt.backup"))
