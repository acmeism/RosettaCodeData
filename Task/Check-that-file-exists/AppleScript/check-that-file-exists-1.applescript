use framework "Foundation" -- YOSEMITE OS X onwards
use scripting additions

on run
    setCurrentDirectory("~/Desktop")

    ap({doesFileExist, doesDirectoryExist}, ¬
        {"input.txt", "/input.txt", "docs", "/docs"})

    --> {true, true, true, true, false, false, true, true}

    -- The first four booleans are returned by `doesFileExist`.

    -- The last four are returned by `doesDirectoryExist`,
    -- which yields false for simple files, and true for directories.
end run

-- GENERIC SYSTEM DIRECTORY FUNCTIONS -----------------------------------------

-- doesDirectoryExist :: String -> Bool
on doesDirectoryExist(strPath)
    set ca to current application
    set oPath to (ca's NSString's stringWithString:strPath)'s ¬
        stringByStandardizingPath
    set {bln, int} to (ca's NSFileManager's defaultManager()'s ¬
        fileExistsAtPath:oPath isDirectory:(reference))
    bln and (int = 1)
end doesDirectoryExist

-- doesFileExist :: String -> Bool
on doesFileExist(strPath)
    set ca to current application
    set oPath to (ca's NSString's stringWithString:strPath)'s ¬
        stringByStandardizingPath
    ca's NSFileManager's defaultManager()'s fileExistsAtPath:oPath
end doesFileExist

-- getCurrentDirectory :: String
on getCurrentDirectory()
    set ca to current application
    ca's NSFileManager's defaultManager()'s currentDirectoryPath as string
end getCurrentDirectory

-- getFinderDirectory :: String
on getFinderDirectory()
    tell application "Finder" to POSIX path of (insertion location as alias)
end getFinderDirectory

-- getHomeDirectory :: String
on getHomeDirectory()
    (current application's NSHomeDirectory() as string)
end getHomeDirectory

-- setCurrentDirectory :: String -> IO ()
on setCurrentDirectory(strPath)
    if doesDirectoryExist(strPath) then
        set ca to current application
        set oPath to (ca's NSString's stringWithString:strPath)'s ¬
            stringByStandardizingPath
        ca's NSFileManager's defaultManager()'s ¬
            changeCurrentDirectoryPath:oPath
    end if
end setCurrentDirectory


-- GENERIC HIGHER ORDER FUNCTIONS FOR THE TEST --------------------------------

-- A list of functions applied to a list of arguments
-- (<*> | ap) :: [(a -> b)] -> [a] -> [b]
on ap(fs, xs)
    set {intFs, intXs} to {length of fs, length of xs}
    set lst to {}
    repeat with i from 1 to intFs
        tell mReturn(item i of fs)
            repeat with j from 1 to intXs
                set end of lst to |λ|(contents of (item j of xs))
            end repeat
        end tell
    end repeat
    return lst
end ap

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn
