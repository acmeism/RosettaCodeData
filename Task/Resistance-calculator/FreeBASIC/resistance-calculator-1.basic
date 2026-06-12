Const NULL As Any Ptr = 0

Type Resistor
    symbol As String
    resistance As Double
    voltage As Double
    a As Resistor Ptr
    b As Resistor Ptr
End Type

Function res(r As Resistor Ptr) As Double
    Select Case r->symbol
    Case "+"
        Return res(r->a) + res(r->b)
    Case "*"
        Return 1 / (1 / res(r->a) + 1 / res(r->b))
    Case Else
        Return r->resistance
    End Select
End Function

Sub setVoltage(r As Resistor Ptr, voltage As Double)
    Select Case r->symbol
    Case "+"
        Dim ra As Double = res(r->a)
        Dim rb As Double = res(r->b)
        setVoltage(r->a, ra / (ra + rb) * voltage)
        setVoltage(r->b, rb / (ra + rb) * voltage)
    Case "*"
        setVoltage(r->a, voltage)
        setVoltage(r->b, voltage)
    End Select
    r->voltage = voltage
End Sub

Function current(r As Resistor Ptr) As Double
    Return r->voltage / res(r)
End Function

Function effect(r As Resistor Ptr) As Double
    Return current(r) * r->voltage
End Function

Sub report(r As Resistor Ptr, level As String)
    Print Using "###.### ###.### ###.### ###.### & &"; res(r); r->voltage; current(r); effect(r); level; r->symbol
    If r->a <> NULL Then report(r->a, level + " |")
    If r->b <> NULL Then report(r->b, level + " |")
End Sub

Function sum(r1 As Resistor Ptr, r2 As Resistor Ptr) As Resistor Ptr
    Dim r As Resistor Ptr = Callocate(1, Sizeof(Resistor))
    r->symbol = "+"
    r->a = r1
    r->b = r2
    Return r
End Function

Function mul(r1 As Resistor Ptr, r2 As Resistor Ptr) As Resistor Ptr
    Dim r As Resistor Ptr = Callocate(1, Sizeof(Resistor))
    r->symbol = "*"
    r->a = r1
    r->b = r2
    Return r
End Function

Dim As Resistor Ptr r(9)
Dim As Double resistances(9) = {6, 8, 4, 8, 4, 6, 8, 10, 6, 2}
For i As Integer = 0 To 9
    r(i) = Callocate(1, Sizeof(Resistor))
    r(i)->symbol = "r"
    r(i)->resistance = resistances(i)
Next
Dim As Resistor Ptr node
node = sum(r(7), r(9))
node = mul(node, r(8))
node = sum(node, r(6))
node = mul(node, r(5))
node = sum(node, r(4))
node = mul(node, r(3))
node = sum(node, r(2))
node = mul(node, r(1))
node = sum(node, r(0))
setVoltage(node, 18)
Print "    Ohm   Volt   Ampere    Watt  Network tree"
report(node, "")

Sleep
