Set dict = CreateObject("Scripting.Dictionary")
os = Array("Windows", "Linux", "MacOS")
owner = Array("Microsoft", "Linus Torvalds", "Apple")
For n = 0 To 2
    dict.Add os(n), owner(n)
Next
MsgBox dict.Item("Linux")
MsgBox dict.Item("MacOS")
MsgBox dict.Item("Windows")
