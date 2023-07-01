Declare Function libPlaySound Lib "winmm.dll" Alias "sndPlaySoundA" _
    (ByVal filename As String, ByVal Flags As Long) As Long

Sub PlaySound(sWav As String)
  Call libPlaySound(sWav, 1) '1 to play asynchronously
End Sub
