Public Sub LetterFrequency(fname)
'count number of letters in text file "fname" (ASCII-coded)
'note: we count all characters but print only the letter frequencies

Dim Freqs(255) As Long
Dim abyte As Byte
Dim ascal as Byte 'ascii code for lowercase a
Dim ascau as Byte 'ascii code for uppercase a

'try to open the file
On Error GoTo CantOpen
Open fname For Input As #1
On Error GoTo 0

'initialize
For i = 0 To 255
  Freqs(i) = 0
Next i

'process file byte-per-byte
While Not EOF(1)
 abyte = Asc(Input(1, #1))
 Freqs(abyte) = Freqs(abyte) + 1
Wend
Close #1

'add lower and upper case together and print result
Debug.Print "Frequencies:"
ascal = Asc("a")
ascau = Asc("A")
For i = 0 To 25
  Debug.Print Chr$(ascal + i), Freqs(ascal + i) + Freqs(ascau + i)
Next i
Exit Sub

CantOpen:
  Debug.Print "can't find or read the file "; fname
  Close
End Sub
