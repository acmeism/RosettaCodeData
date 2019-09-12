Sub Main()
  Debug.Assert LuhnCheckPassed("49927398716")
  Debug.Assert Not LuhnCheckPassed("49927398717")
  Debug.Assert Not LuhnCheckPassed("1234567812345678")
  Debug.Assert LuhnCheckPassed("1234567812345670")
End Sub
