import "os" for Process
import "io" for File
import "./ioutil" for Input

var sec = "00:00:01"

var name    =  Input.text   ("Enter name of audio file to be trimmed : ", 1, 80)
var name2   =  Input.text   ("Enter name of output file              : ", 1, 80)
var squelch =  Input.number ("Enter squelch level \% max (1 to 10)    : ", 1, 10)

var squelchS = squelch.toString + "\%"

var tmp1 = "tmp1_" + name
var tmp2 = "tmp2_" + name

// Trim audio below squelch level from start and output to tmp1.
var args = [name, tmp1, "silence", "1", sec, squelchS]
Process.exec("sox", args)

// Reverse tmp1 to tmp2.
args = [tmp1, tmp2, "reverse"]
Process.exec("sox", args)

// Trim audio below squelch level from tmp2 and output to tmp1.
args = [tmp2, tmp1, "silence", "1", sec, squelchS]
Process.exec("sox", args)

// Reverse tmp1 to the output file.
args = [tmp1, name2, "reverse"]
Process.exec("sox", args)

// Remove the temporary files.
File.delete(tmp1)
File.delete(tmp2)
