Type mwriter
    value As Double
    log_ As String
End Type

Function Unit(v As Double, s As String) As mwriter
    Dim As mwriter mw
    mw.value = v
    mw.log_ = "  " & s & ": " & Str(v) & Chr(10)
    Return mw
End Function

Function Root(mw As mwriter) As mwriter
    mw.value = Sqr(mw.value)
    mw.log_ = mw.log_ & "  Took square Root: " & Str(mw.value) & Chr(10)
    Return mw
End Function

Function addOne(mw As mwriter) As mwriter
    mw.value = mw.value + 1
    mw.log_ = mw.log_ & "  Added one       : " & Str(mw.value) & Chr(10)
    Return mw
End Function

Function Half(mw As mwriter) As mwriter
    mw.value = mw.value / 2
    mw.log_ = mw.log_ & "  Divided by two  : " & Str(mw.value) & Chr(10)
    Return mw
End Function

Dim As mwriter mw1
mw1 = Unit(5, "Initial value   ")
mw1 = Root(mw1)
mw1 = addOne(mw1)
mw1 = Half(mw1)
Print "The Golden Ratio is "; mw1.value
Print !"\nThis was derived as follows:-"
Print mw1.log_

Sleep
