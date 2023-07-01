import "os" for Process
import "/ioutil" for File, FileUtil
import "/date" for Date

var dateFormatIn  = "yyyy|-|mm|-|dd|+|hh|:|MM"
var dateFormatOut = "yyyy|-|mm|-|dd| |hh|:|MM"
var args = Process.arguments
if (args.count == 0) {
    if (File.exists("NOTES.TXT")) System.print(File.read("NOTES.TXT"))
} else if (args.count == 1) {
    System.print("Enter the current date/time (MM/DD+HH:mm) plus at least one other argument.")
} else {
    var dateTime = Date.parse(args[0], dateFormatIn)
    var note = "\t" + args[1..-1].join(" ") + "\n"
    FileUtil.append("NOTES.TXT", dateTime.format(dateFormatOut) + "\n" + note)
}
