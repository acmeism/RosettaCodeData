use framework "Foundation"
use scripting additions


-- createOrFindDirectoryMay :: Bool -> FilePath -> Maybe IO ()
on createOrFindDirectoryMay(fp)
    createDirectoryIfMissingMay(true, fp)
end createOrFindDirectoryMay


-- createDirectoryIfMissingMay :: Bool -> FilePath -> Maybe IO ()
on createDirectoryIfMissingMay(blnParents, fp)
    if doesPathExist(fp) then
        nothing("Directory already exists: " & fp)
    else
        set e to reference
        set ca to current application
        set oPath to (ca's NSString's stringWithString:(fp))'s ¬
            stringByStandardizingPath
        set {bool, nse} to ca's NSFileManager's ¬
            defaultManager's createDirectoryAtPath:(oPath) ¬
            withIntermediateDirectories:(blnParents) ¬
            attributes:(missing value) |error|:(e)
        if bool then
            just(fp)
        else
            nothing((localizedDescription of nse) as string)
        end if
    end if
end createDirectoryIfMissingMay

-- TEST ----------------------------------------------------------------------
on run

    createOrFindDirectoryMay("~/Desktop/Notes/today")

end run

-- GENERIC FUNCTIONS ---------------------------------------------------------

-- doesPathExist :: FilePath -> IO Bool
on doesPathExist(strPath)
    set ca to current application
    ca's NSFileManager's defaultManager's ¬
        fileExistsAtPath:((ca's NSString's ¬
            stringWithString:strPath)'s ¬
            stringByStandardizingPath)
end doesPathExist

-- just :: a -> Just a
on just(x)
    {nothing:false, just:x}
end just

-- nothing :: () -> Nothing
on nothing(msg)
    {nothing:true, msg:msg}
end nothing
