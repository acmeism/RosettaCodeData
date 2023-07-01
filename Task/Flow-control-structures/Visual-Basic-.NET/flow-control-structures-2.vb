   Sub foo()
       On Error GoTo label
       'do something dangerous
       Exit Sub
label:
       Console.WriteLine("Operation Failed")
   End Sub
