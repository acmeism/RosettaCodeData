import "io" for File, FileFlags

var records = [
    "jsmith:x:1001:1000:Joe Smith,Room 1007,(234)555-8917,(234)555-0077,[email protected]:/home/jsmith:/bin/bash",
    "jdoe:x:1002:1000:Jane Doe,Room 1004,(234)555-8914,(234)555-0044,[email protected]:/home/jdoe:/bin/bash"
]

// Write records to a new file called "passwd.csv" and close it.
var fileName = "passwd.csv"
File.create(fileName) {|file|
    records.each { |r| file.writeBytes(r + "\n") }
}

// Check file has been created correctly.
var contents = File.read(fileName)
System.print("Initial records:\n")
System.print(contents)

var newRec = "xyz:x:1003:1000:X Yz,Room 1003,(234)555-8913,(234)555-0033,[email protected]:/home/xyz:/bin/bash"

// Append the new record to the file and close it.
File.openWithFlags(fileName, FileFlags.writeOnly) { |file|
    file.writeBytes(newRec + "\n")
}

// Check the new record has been appended correctly.
contents = File.read(fileName)
System.print("Records after appending new one:\n")
System.print(contents)
