/* file_mod_time_wren */

import "./date" for Date

foreign class Stat {
    construct new(fileName) {}

    foreign atime
    foreign mtime
}

foreign class Utimbuf {
    construct new(actime, modtime) {}

    foreign utime(fileName)
}

// gets a Date object from a Unix time in seconds
var UT2Date = Fn.new { |ut| Date.unixEpoch.addSeconds(ut) }

Date.default = "yyyy|-|mm|-|dd| |hh|:|MM|:|ss" // default format for printing

var fileName = "temp.txt"
var st = Stat.new(fileName)
System.print("'%(fileName)' was last modified on %(UT2Date.call(st.mtime)).")

var utb = Utimbuf.new(st.atime, 0) // atime unchanged, mtime = current time
if (utb.utime(fileName) < 0) {
    System.print("There was an error changing the file modification time.")
    return
}
st = Stat.new(fileName) // update info
System.print("File modification time changed to %(UT2Date.call(st.mtime)).")
