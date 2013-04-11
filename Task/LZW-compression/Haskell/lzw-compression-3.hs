*Main> (ap (==) . liftM2 (.) undoLZW doLZW) ['\0'..'\255'] "TOBEORNOTTOBEORTOBEORNOT"
True
