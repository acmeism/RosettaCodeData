' Euclidean rhythm

Function EuclideanRhythm(M As Integer, N As Integer) As String
  ReDim R(N - 1) As String
  Dim AStart, AEnd, BStart, BEnd, APos, BPos As Integer
  Dim I As Integer
  Dim Result As String
  AStart = 0
  AEnd = M - 1
  BStart = M
  BEnd = N - 1
  For I = AStart To AEnd
    R(I) = 1
  Next I
  For I = BStart To BEnd
    R(I) = 0
  Next I
  Do While (AEnd > AStart) And (BEnd > BStart)
    APos = AStart
    BPos = BStart
    Do While (APos <= AEnd) And (BPos <= BEnd)
      R(APos) = R(APos) & R(BPos)
      APos = APos + 1
      BPos = BPos + 1
    Loop
    If BPos <= BEnd Then
      BStart = BPos
    Else
      BStart = APos
      BEnd = AEnd
      AEnd = APos - 1
    End If
  Loop
  Result = ""
  For I = AStart To AEnd
    Result = Result & R(I)
  Next I
  For I = BStart To BEnd
    Result = Result & R(I)
  Next I
  EuclideanRhythm = Result
End Function

Sub EuclideanRhythmMain()
  Debug.Print EuclideanRhythm(5, 13)
  Debug.Print EuclideanRhythm(3, 8)
End Sub
