Option Explicit

Dim objFSO, DBSource

Set objFSO = CreateObject("Scripting.FileSystemObject")

DBSource = objFSO.GetParentFolderName(WScript.ScriptFullName) & "\postal_address.accdb"

With CreateObject("ADODB.Connection")
	.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & DBSource
	.Execute "CREATE TABLE ADDRESS (STREET VARCHAR(30) NOT NULL," &_
			"CITY VARCHAR(30) NOT NULL, STATE CHAR(2) NOT NULL,ZIP CHAR(5) NOT NULL)"
	.Close
End With
