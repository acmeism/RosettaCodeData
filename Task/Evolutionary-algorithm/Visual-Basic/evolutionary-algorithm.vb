Option Explicit

Private Sub Main()
   Dim Target
   Dim Parent
   Dim mutation_rate
   Dim children
   Dim bestfitness
   Dim bestindex
   Dim Index
   Dim fitness

      Target = "METHINKS IT IS LIKE A WEASEL"
      Parent = "IU RFSGJABGOLYWF XSMFXNIABKT"
      mutation_rate = 0.5
       children = 10
      ReDim child(children)

      Do
        bestfitness = 0
        bestindex = 0
        For Index = 1 To children
          child(Index) = FNmutate(Parent, mutation_rate, Target)
          fitness = FNfitness(Target, child(Index))
          If fitness > bestfitness Then
            bestfitness = fitness
            bestindex = Index
          End If
        Next Index

        Parent = child(bestindex)
        Debug.Print Parent
      Loop Until Parent = Target
      End


End Sub

Function FNmutate(Text, Rate, ref)
   Dim C As Integer
   Dim Aux As Integer

     If Rate > Rnd(1) Then
        C = 63 + 27 * Rnd() + 1
        If C = 64 Then C = 32
        Aux = Len(Text) * Rnd() + 1
        If Mid(Text, Aux, 1) <> Mid(ref, Aux, 1) Then
            Text = Left(Text, Aux - 1) & Chr(C) & Mid(Text, Aux + 1)
        End If

     End If
      FNmutate = Text
End Function
Function FNfitness(Text, ref)
    Dim I, F
      For I = 1 To Len(Text)
        If Mid(Text, I, 1) = Mid(ref, I, 1) Then F = F + 1
      Next
      FNfitness = F / Len(Text)
End Function
