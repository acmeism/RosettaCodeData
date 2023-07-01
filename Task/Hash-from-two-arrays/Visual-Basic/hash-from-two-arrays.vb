Dim dict As New Collection
os = Array("Windows", "Linux", "MacOS")
owner = Array("Microsoft", "Linus Torvalds", "Apple")
For n = 0 To 2
    dict.Add owner(n), os(n)
Next
Debug.Print dict.Item("Linux")
Debug.Print dict.Item("MacOS")
Debug.Print dict.Item("Windows")
