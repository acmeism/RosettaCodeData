import "./date" for Date
import "./ioutil" for File, FileUtil

var syncSubtitles = Fn.new { |fileIn, fileOut, secs|
    var nl = FileUtil.lineBreak
    var fmt = "hh|:|MM|:|ss|,|ttt"
    var f = File.create(fileOut)
    for (line in FileUtil.readLines(fileIn)) {
        if (line.contains("-->")) {
            var start = line[0..11]
            var startDate = Date.parse(start, fmt).addSeconds(secs)
            start = startDate.format(fmt)
            var end = line[17..28]
            var endDate = Date.parse(end, fmt).addSeconds(secs)
            end = endDate.format(fmt)
            f.writeBytes(start + " --> " + end + nl)
         } else {
            f.writeBytes(line + nl)
         }
    }
    f.close()
}

System.print("After fast-forwarding 9 seconds:\n")
syncSubtitles.call("movie.srt", "movie_corrected.srt", 9)
System.print(File.read("movie_corrected.srt"))
System.print("After rolling-back 9 seconds:\n")
syncSubtitles.call("movie.srt", "movie_corrected2.srt", -9)
System.print(File.read("movie_corrected2.srt"))
