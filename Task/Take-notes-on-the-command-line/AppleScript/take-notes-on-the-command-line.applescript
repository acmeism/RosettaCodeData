#!/usr/bin/osascript

-- format a number as a string with leading zero if needed
to format(aNumber)
  set resultString to aNumber as text
  if length of resultString < 2
    set resultString to "0" & resultString
  end if
  return resultString
end format

-- join a list with a delimiter
to concatenation of aList given delimiter:aDelimiter
  set tid to AppleScript's text item delimiters
  set AppleScript's text item delimiters to { aDelimiter }
  set resultString to aList as text
  set AppleScript's text item delimiters to tid
  return resultString
end join

-- apply a handler to every item in a list, returning
-- a list of the results
to mapping of aList given function:aHandler
  set resultList to {}
  global h
  set h to aHandler
  repeat with anItem in aList
    set resultList to resultList & h(anItem)
  end repeat
  return resultList
end mapping

-- return an ISO-8601-formatted string representing the current date and time
-- in UTC
to iso8601()
    set { year:y,   month:m,     day:d, ¬
          hours:hr, minutes:min, seconds:sec } to ¬
          (current date) - (time to GMT)
    set ymdList to the mapping of { y, m as integer, d } given function:format
    set ymd to the concatenation of ymdList given delimiter:"-"
    set hmsList to the mapping of { hr, min, sec } given function:format
    set hms to the concatenation of hmsList given delimiter:":"
    set dateTime to the concatenation of {ymd, hms} given delimiter:"T"
    return dateTime & "Z"
end iso8601

to exists(filePath)
  try
    filePath as alias
    return true
  on error
    return false
  end try
end exists

on run argv
  set curDir to (do shell script "pwd")
  set notesFile to POSIX file (curDir & "/NOTES.TXT")

  if (count argv) is 0 then
    if exists(notesFile) then
       set text item delimiters to {linefeed}
       return paragraphs of (read notesFile) as text
    else
       log "No notes here."
       return
    end if
  else
    try
      set fd to open for access notesFile with write permission
      write (iso8601() & linefeed & tab) to fd starting at eof
      set AppleScript's text item delimiters to {" "}
      write ((argv as text) & linefeed) to fd starting at eof
      close access fd
      return true
    on error errMsg number errNum
      try
         close access fd
      end try
      return "unable to open  " & notesFile & ": " & errMsg
    end try
  end if
end run
