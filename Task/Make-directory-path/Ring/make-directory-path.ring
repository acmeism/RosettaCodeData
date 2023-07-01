System("mkdir C:\Ring\docs")
isdir("C:\Ring\docs")

see isdir("C:\Ring\docs") + nl
func isdir cDir
     try
        dir(cDir)
        return true
     catch
        return false
     done
