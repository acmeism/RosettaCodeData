Function Min(E1, E2): Min = IIf(E1 < E2, E1, E2): End Function 'small Helper-Function

Sub Main()
Const Value = 0, Weight = 1, Volume = 2, PC = 3, IC = 4, GC = 5
Dim P&, I&, G&, A&, M, Cur(Value To Volume)
Dim S As New Collection: S.Add Array(0) '<- init Solutions-Coll.

Const SackW = 25, SackV = 0.25
Dim Panacea: Panacea = Array(3000, 0.3, 0.025)
Dim Ichor:     Ichor = Array(1800, 0.2, 0.015)
Dim Gold:       Gold = Array(2500, 2, 0.002)

  For P = 0 To Int(Min(SackW / Panacea(Weight), SackV / Panacea(Volume)))
    For I = 0 To Int(Min(SackW / Ichor(Weight), SackV / Ichor(Volume)))
      For G = 0 To Int(Min(SackW / Gold(Weight), SackV / Gold(Volume)))
        For A = Value To Volume: Cur(A) = G * Gold(A) + I * Ichor(A) + P * Panacea(A): Next
        If Cur(Value) >= S(1)(Value) And Cur(Weight) <= SackW And Cur(Volume) <= SackV Then _
          S.Add Array(Cur(Value), Cur(Weight), Cur(Volume), P, I, G), , 1
  Next G, I, P

  Debug.Print "Value", "Weight", "Volume", "PanaceaCount", "IchorCount", "GoldCount"
  For Each M In S '<- enumerate the Attributes of the Maxima
    If M(Value) = S(1)(Value) Then Debug.Print M(Value), M(Weight), M(Volume), M(PC), M(IC), M(GC)
  Next
End Sub
