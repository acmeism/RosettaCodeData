Public Sub test()
    'LTrim trims leading spaces
    'RTrim trims tailing spaces
    'Trim trims both leading and tailing spaces
    s = " trim "
    Debug.Print """" & s & """"
    Debug.Print """" & LTrim(s) & """"
    Debug.Print """" & RTrim(s) & """"
    Debug.Print """" & WorksheetFunction.trim(s) & """"
    'these functions do not remove tabs or newlines
End Sub
