#Requires AutoHotkey v2.0
#SingleInstance Force
FileEncoding "UTF-8"

words := []

; load words containing only letters between 4 and 9 letters long
try
    loop read "unixdict.txt"
        if RegExMatch(A_LoopReadLine, "^[a-z]{4,9}$")
            words.Push(A_LoopReadLine)
catch as err {
    MsgBox "Failed to process dictionary file:`n" err.Message, "Error", "IconX"
    ExitApp 1
}

; create graphical user interface
MyGui := Gui(, "Passphrase Generator")
MyGui.AddText(, "Number of words in passphrase:")
dropDown := MyGui.AddDropDownList("Choose3 w60", [3, 4, 5, 6, 7])
MyGui.AddButton(, "Generate")
    .OnEvent("Click", (*) => out.Value := genPassphrase(Integer(dropDown.Text)))
out := MyGui.AddEdit("ReadOnly w480")
MyGui.Show()

; generate a passphrase with a given number of words
genPassphrase(n) {
    passphrase := ""
    loop n {
        passphrase .= StrTitle(words[Random(1, words.Length)])
        passphrase .= Random(10, 99)
        if A_Index < n
            passphrase .= "-"
    }
    return passphrase
}
