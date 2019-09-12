Public Function timedelta(Optional weeks As Integer = 0, Optional days As Integer = 0, _
    Optional hours As Integer = 0, Optional minutes As Integer = 0, Optional seconds As Integer = 0, _
    Optional milliseconds As Integer = 0, Optional microseconds As Integer = 0) As Variant
End Function
Public Sub main()
    '-- can be invoked as:
    fourdays = timedelta(days:=4)
    '--       fourdays = timedelta(0,4) '-- equivalent
    '-- **NB** a plain '=' is a very different thing
    oneday = timedelta(days = 1) '-- equivalent to timedelta([weeks:=]IIf((days=1,-1:0))
                                        '-- with NO error if no local variable days exists.
                                        'VBA will assume local variable days=0
    Dim hours As Integer
    shift = timedelta(hours:=hours) '-- perfectly valid (param hours:=local hours)
    '-- timedelta(0,hours:=15,3) '-- illegal (it is not clear whether you meant days:=3 or minutes:=3)
                                 'VBA expects a named parameter for 3
End Sub
