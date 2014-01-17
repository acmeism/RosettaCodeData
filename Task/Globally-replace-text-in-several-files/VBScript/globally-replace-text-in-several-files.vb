Const ForReading = 1
Const ForWriting = 2

strFiles = Array("test1.txt", "test2.txt", "test3.txt")

With CreateObject("Scripting.FileSystemObject")
	For i = 0 To UBound(strFiles)
		strText = .OpenTextFile(strFiles(i), ForReading).ReadAll()
		With .OpenTextFile(strFiles(i), ForWriting)
			.Write Replace(strText, "Goodbye London!", "Hello New York!")
			.Close
		End With
	Next
End With
