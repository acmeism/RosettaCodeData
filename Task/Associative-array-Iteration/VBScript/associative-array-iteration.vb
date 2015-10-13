'instantiate the dictionary object
Set dict = CreateObject("Scripting.Dictionary")

'populate the dictionary or hash table
dict.Add 1,"larry"
dict.Add 2,"curly"
dict.Add 3,"moe"

'iterate key and value pairs
For Each key In dict.Keys
	WScript.StdOut.WriteLine key & " - " & dict.Item(key)
Next
