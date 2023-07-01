Option Explicit

Sub InsertForm()
Dim myForm As Object, strname As String
    Set myForm = ThisWorkbook.VBProject.VBComponents.Add(3)
    strname = myForm.Name
    VBA.UserForms.Add(strname).Show
End Sub
