import System.Posix.Files
import System.Posix.Time

do status <- getFileStatus filename
   let atime = accessTime status
       mtime = modificationTime status -- seconds since the epoch
   curTime <- epochTime
   setFileTimes filename atime curTime -- keep atime unchanged
                                       -- set mtime to current time
