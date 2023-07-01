Public Sub orderedwords(fname As String)
 ' find ordered words in dict file that have the longest word length
 ' fname is the name of the input file
 ' the words are printed in the immediate window
 ' this subroutine uses boolean function IsOrdered

Dim word As String          'word to be tested
Dim l As Integer            'length of word
Dim wordlength As Integer   'current longest word length
Dim orderedword() As String 'dynamic array holding the ordered words with the current longest word length
Dim wordsfound As Integer   'length of the array orderedword()

On Error GoTo NotFound      'catch incorrect/missing file name
Open fname For Input As #1
On Error GoTo 0

'initialize
wordsfound = 0
wordlength = 0

'process file line per line
While Not EOF(1)
  Line Input #1, word
  If IsOrdered(word) Then    'found one, is it equal to or longer than current word length?
    l = Len(word)
    If l >= wordlength Then  'yes, so add to list or start a new list
      If l > wordlength Then 'it's longer, we must start a new list
        wordsfound = 1
        wordlength = l
      Else                   'equal length, increase the list size
        wordsfound = wordsfound + 1
      End If
      'add the word to the list
      ReDim Preserve orderedword(wordsfound)
      orderedword(wordsfound) = word
    End If
  End If
Wend
Close #1

'print the list
Debug.Print "Found"; wordsfound; "ordered words of length"; wordlength
For i = 1 To wordsfound
  Debug.Print orderedword(i)
Next
Exit Sub

NotFound:
  debug.print "Error: Cannot find or open file """ & fname & """!"
End Sub



Public Function IsOrdered(someWord As String) As Boolean
'true if letters in word are in ascending (ascii) sequence

Dim l As Integer         'length of someWord
Dim wordLcase As String  'the word in lower case
Dim ascStart As Integer  'ascii code of first char
Dim asc2 As Integer      'ascii code of next char

wordLcase = LCase(someWord)  'convert to lower case
l = Len(someWord)
IsOrdered = True
If l > 0 Then            'this skips empty string - it is considered ordered...
  ascStart = Asc(Left$(wordLcase, 1))
  For i = 2 To l
    asc2 = Asc(Mid$(wordLcase, i, 1))
    If asc2 < ascStart Then 'failure!
      IsOrdered = False
      Exit Function
    End If
    ascStart = asc2
  Next i
End If
End Function
