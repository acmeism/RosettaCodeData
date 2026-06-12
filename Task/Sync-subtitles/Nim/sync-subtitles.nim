import std/[os, strformat, strscans, times]

const SrtTimeFormat = "HH:mm:ss,fff"

proc `+=`(timeStr: var string; secs: int) =
  ## Update the time string by adding "secs" seconds.
  var t = parseTime(timeStr, SrtTimeFormat, utc())
  t += initDuration(seconds = secs)
  timeStr = t.format(SrtTimeFormat, utc())


proc syncSubtitles(inFileName, outFileName: string; secs: int) =
  ## Synchronize subtitles in a file by adding "secs" seconds.
  let outFile = open(outFileName, fmWrite)
  for line in lines(inFileName):
    var startStr, endStr: string
    if line.scanf("$+ --> $+$.", startStr, endStr):
      startStr += secs
      endStr += secs
      outFile.writeLine &"{startStr} --> {endStr}"
    else:
      outFile.writeLine line
  outFile.close()


when isMainModule:

  const
    InFile = "movie.srt"
    OutFile = "movie_corrected.srt"

  echo "After fast-forwarding 9 seconds:\n"
  syncSubtitles(InFile, OutFile, 9)
  for line in lines(OutFile):
    echo line

  echo "\n\nAfter rolling-back 9 seconds:\n"
  syncSubtitles(InFile, OutFile, -9)
  for line in lines(OutFile):
    echo line

  removeFile OutFile
