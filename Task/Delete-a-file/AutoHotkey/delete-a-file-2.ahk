DeleteFile(lpFileName)
{
    DllCall("Kernel32.dll\DeleteFile", "Str", lpFileName)
}

DeleteFile("C:\Temp\TestFile.txt")
