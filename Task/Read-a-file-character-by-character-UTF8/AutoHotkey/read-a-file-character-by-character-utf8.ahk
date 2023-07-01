File := FileOpen("input.txt", "r")
while !File.AtEOF
    MsgBox, % File.Read(1)
