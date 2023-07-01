Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objInFile = objFSO.OpenTextFile(objFSO.GetParentFolderName(WScript.ScriptFullName) &_
	"\unixdict.txt",1)
Set objKeyMap = CreateObject("Scripting.Dictionary")
	With objKeyMap
		.Add "ABC", "2" : .Add "DEF", "3" : .Add "GHI", "4" : .Add "JKL", "5"
		.Add "MNO", "6" : .Add "PQRS", "7" : .Add "TUV", "8" : .Add "WXYZ", "9"
	End With

'Instantiate or Intialize Counters
TotalWords = 0
UniqueCombinations = 0
Set objUniqueWords = CreateObject("Scripting.Dictionary")
Set objMoreThanOneWord = CreateObject("Scripting.Dictionary")

Do Until objInFile.AtEndOfStream
	Word = objInFile.ReadLine
	c = 0
	Num = ""
	If Word <> "" Then
		For i = 1 To Len(Word)
			For Each Key In objKeyMap.Keys
				If InStr(1,Key,Mid(Word,i,1),1) > 0 Then
					Num = Num & objKeyMap.Item(Key)
					c = c + 1
				End If
			Next
		Next
		If c = Len(Word) Then
			TotalWords = TotalWords + 1
			If objUniqueWords.Exists(Num) = False Then
				objUniqueWords.Add Num, ""
				UniqueCombinations = UniqueCombinations + 1
			Else
				If objMoreThanOneWord.Exists(Num) = False Then
					objMoreThanOneWord.Add Num, ""
				End If
			End If
		End If
	End If
Loop	

WScript.Echo "There are " & TotalWords & " words in ""unixdict.txt"" which can be represented by the digit key mapping." & vbCrLf &_
			 "They require " & UniqueCombinations & " digit combinations to represent them." & vbCrLf &_
                         objMoreThanOneWord.Count &  " digit combinations represent Textonyms."

objInFile.Close
