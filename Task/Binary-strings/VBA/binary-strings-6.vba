Sub Check_Is_Empty()
Dim A As String, B As Variant

    Debug.Print IsEmpty(A)          'return False
    Debug.Print IsEmpty(Null)       'return False
    Debug.Print IsEmpty(B)          'return True ==> B is a Variant

    Debug.Print A = vbNullString    'return True
    Debug.Print StrPtr(A)           'return 0 (zero)

    'Press the OK button without enter a data in the InputBox :
    A = InputBox("Enter your own String : ")
    Debug.Print A = ""              'return True
    Debug.Print IsEmpty(A)          'return False
    Debug.Print StrPtr(A) = 0       'return False

    'Press the cancel button (with or without enter a data in the InputBox)
    A = InputBox("Enter your own String : ")
    Debug.Print StrPtr(A) = 0       'return True
    Debug.Print IsEmpty(A)          'return False
    Debug.Print A = ""              'return True
    'Note : StrPtr is the only way to know if you cancel the inputbox
End Sub
