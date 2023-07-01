'--- mdRipeMd160.bas
Option Explicit
DefObj A-Z

#Const HasPtrSafe = (VBA7 <> 0)
#Const HasOperators = (TWINBASIC <> 0)

#If HasPtrSafe Then
Private Declare PtrSafe Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As LongPtr)
Private Declare PtrSafe Function WideCharToMultiByte Lib "kernel32" (ByVal CodePage As Long, ByVal dwFlags As Long, ByVal lpWideCharStr As LongPtr, ByVal cchWideChar As Long, lpMultiByteStr As Any, ByVal cchMultiByte As Long, ByVal lpDefaultChar As Long, ByVal lpUsedDefaultChar As Long) As Long
#Else
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)
Private Declare Function WideCharToMultiByte Lib "kernel32" (ByVal CodePage As Long, ByVal dwFlags As Long, ByVal lpWideCharStr As Long, ByVal cchWideChar As Long, lpMultiByteStr As Any, ByVal cchMultiByte As Long, ByVal lpDefaultChar As Long, ByVal lpUsedDefaultChar As Long) As Long
#End If

Private Const LNG_BLOCKSZ               As Long = 64
Private Const LNG_ROUNDS                As Long = 80
Private Const LNG_HASHSZ                As Long = 20

Public Type CryptoRipeMd160Context
    H0                  As Long
    H1                  As Long
    H2                  As Long
    H3                  As Long
    H4                  As Long
    Partial(0 To LNG_BLOCKSZ - 1) As Byte
    NPartial            As Long
    NInput              As Currency
End Type

Private LNG_R0(0 To LNG_ROUNDS - 1)  As Long
Private LNG_R1(0 To LNG_ROUNDS - 1)  As Long
Private LNG_S0(0 To LNG_ROUNDS - 1)  As Long
Private LNG_S1(0 To LNG_ROUNDS - 1)  As Long

#If Not HasOperators Then
Private LNG_POW2(0 To 31)           As Long

Private Function RotL32(ByVal lX As Long, ByVal lN As Long) As Long
    '--- RotL32 = LShift(X, n) Or RShift(X, 32 - n)
    Debug.Assert lN <> 0
    RotL32 = ((lX And (LNG_POW2(31 - lN) - 1)) * LNG_POW2(lN) Or -((lX And LNG_POW2(31 - lN)) <> 0) * LNG_POW2(31)) Or _
        ((lX And (LNG_POW2(31) Xor -1)) \ LNG_POW2(32 - lN) Or -(lX < 0) * LNG_POW2(lN - 1))
End Function

Private Function UAdd32(ByVal lX As Long, ByVal lY As Long) As Long
    If (lX Xor lY) >= 0 Then
        UAdd32 = ((lX Xor &H80000000) + lY) Xor &H80000000
    Else
        UAdd32 = lX + lY
    End If
End Function
#End If

Public Sub CryptoRipeMd160Init(uCtx As CryptoRipeMd160Context)
    Dim vElem           As Variant
    Dim lIdx            As Long

    If LNG_R0(0) = 0 Then
        For Each vElem In Split("0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 7 4 13 1 10 6 15 3 12 0 9 5 2 14 11 8 3 10 14 4 9 15 8 1 2 7 0 6 13 11 5 12 1 9 11 10 0 8 12 4 13 3 7 15 14 5 6 2 4 0 5 9 7 12 2 10 14 1 3 8 11 6 15 13 5 14 7 0 9 2 11 4 13 6 15 8 1 10 3 12 6 11 3 7 0 13 5 10 14 15 8 12 4 9 1 2 15 5 1 3 7 14 6 9 11 8 12 2 10 0 4 13 8 6 4 1 3 11 15 0 5 12 2 13 9 7 10 14 12 15 10 4 1 5 8 7 6 2 13 14 0 3 9 11")
            If lIdx < LNG_ROUNDS Then
                LNG_R0(lIdx) = vElem
            Else
                LNG_R1(lIdx - LNG_ROUNDS) = vElem
            End If
            lIdx = lIdx + 1
        Next
        lIdx = 0
        For Each vElem In Split("11 14 15 12 5 8 7 9 11 13 14 15 6 7 9 8 7 6 8 13 11 9 7 15 7 12 15 9 11 7 13 12 11 13 6 7 14 9 13 15 14 8 13 6 5 12 7 5 11 12 14 15 14 15 9 8 9 14 5 6 8 6 5 12 9 15 5 11 6 8 13 12 5 12 13 14 11 8 5 6 8 9 9 11 13 15 15 5 7 7 8 11 14 14 12 6 9 13 15 7 12 8 9 11 7 7 12 7 6 15 13 11 9 7 15 11 8 6 6 14 12 13 5 14 13 13 7 5 15 5 8 11 14 14 6 14 6 9 12 9 12 5 15 8 8 5 12 9 12 5 14 6 8 13 6 5 15 13 11 11")
            If lIdx < LNG_ROUNDS Then
                LNG_S0(lIdx) = vElem
            Else
                LNG_S1(lIdx - LNG_ROUNDS) = vElem
            End If
            lIdx = lIdx + 1
        Next
        #If Not HasOperators Then
            LNG_POW2(0) = 1
            For lIdx = 1 To 30
                LNG_POW2(lIdx) = LNG_POW2(lIdx - 1) * 2
            Next
            LNG_POW2(31) = &H80000000
        #End If
    End If
    With uCtx
        .H0 = &H67452301: .H1 = &HEFCDAB89: .H2 = &H98BADCFE: .H3 = &H10325476: .H4 = &HC3D2E1F0
        .NPartial = 0
        .NInput = 0
    End With
End Sub

#If HasOperators Then
[ IntegerOverflowChecks (False) ]
#End If
Public Sub CryptoRipeMd160Update(uCtx As CryptoRipeMd160Context, baInput() As Byte, Optional ByVal Pos As Long, Optional ByVal Size As Long = -1)
    Static B(0 To 15)   As Long
    Dim lIdx            As Long
    Dim lA0             As Long
    Dim lB0             As Long
    Dim lC0             As Long
    Dim lD0             As Long
    Dim lE0             As Long
    Dim lTemp0          As Long
    Dim lK0             As Long
    Dim lA1             As Long
    Dim lB1             As Long
    Dim lC1             As Long
    Dim lD1             As Long
    Dim lE1             As Long
    Dim lTemp1          As Long
    Dim lK1             As Long

    With uCtx
        If Size < 0 Then
            Size = UBound(baInput) + 1 - Pos
        End If
        .NInput = .NInput + Size
        If .NPartial > 0 Then
            lIdx = LNG_BLOCKSZ - .NPartial
            If lIdx > Size Then
                lIdx = Size
            End If
            Call CopyMemory(.Partial(.NPartial), baInput(Pos), lIdx)
            .NPartial = .NPartial + lIdx
            Pos = Pos + lIdx
            Size = Size - lIdx
        End If
        Do While Size > 0 Or .NPartial = LNG_BLOCKSZ
            If .NPartial <> 0 Then
                Call CopyMemory(B(0), .Partial(0), LNG_BLOCKSZ)
                .NPartial = 0
            ElseIf Size >= LNG_BLOCKSZ Then
                Call CopyMemory(B(0), baInput(Pos), LNG_BLOCKSZ)
                Pos = Pos + LNG_BLOCKSZ
                Size = Size - LNG_BLOCKSZ
            Else
                Call CopyMemory(.Partial(0), baInput(Pos), Size)
                .NPartial = Size
                Exit Do
            End If
            '--- RipeMd160 step
            lA0 = .H0: lB0 = .H1: lC0 = .H2: lD0 = .H3: lE0 = .H4
            lA1 = .H0: lB1 = .H1: lC1 = .H2: lD1 = .H3: lE1 = .H4
            For lIdx = 0 To LNG_ROUNDS - 1
                Select Case lIdx \ 16
                Case 0
                    lTemp0 = lB0 Xor lC0 Xor lD0
                    lTemp1 = lB1 Xor (lC1 Or Not lD1)
                    lK0 = 0: lK1 = &H50A28BE6
                Case 1
                    lTemp0 = (lB0 And lC0) Or (Not lB0 And lD0)
                    lTemp1 = (lB1 And lD1) Or (lC1 And Not lD1)
                    lK0 = &H5A827999: lK1 = &H5C4DD124
                Case 2
                    lTemp0 = (lB0 Or Not lC0) Xor lD0
                    lTemp1 = (lB1 Or Not lC1) Xor lD1
                    lK0 = &H6ED9EBA1: lK1 = &H6D703EF3
                Case 3
                    lTemp0 = (lB0 And lD0) Or (lC0 And Not lD0)
                    lTemp1 = (lB1 And lC1) Or (Not lB1 And lD1)
                    lK0 = &H8F1BBCDC: lK1 = &H7A6D76E9
                Case 4
                    lTemp0 = lB0 Xor (lC0 Or Not lD0)
                    lTemp1 = lB1 Xor lC1 Xor lD1
                    lK0 = &HA953FD4E: lK1 = 0
                End Select
                #If HasOperators Then
                    lTemp0 += lA0 + B(LNG_R0(lIdx)) + lK0
                    lTemp0 = (lTemp0 << LNG_S0(lIdx) Or lTemp0 >> (32 - LNG_S0(lIdx))) + lE0
                    lTemp1 += lA1 + B(LNG_R1(lIdx)) + lK1
                    lTemp1 = (lTemp1 << LNG_S1(lIdx) Or lTemp1 >> (32 - LNG_S1(lIdx))) + lE1
                #Else
                    lTemp0 = UAdd32(RotL32(UAdd32(UAdd32(UAdd32(lTemp0, lA0), B(LNG_R0(lIdx))), lK0), LNG_S0(lIdx)), lE0)
                    lTemp1 = UAdd32(RotL32(UAdd32(UAdd32(UAdd32(lTemp1, lA1), B(LNG_R1(lIdx))), lK1), LNG_S1(lIdx)), lE1)
                #End If
                lA0 = lE0: lA1 = lE1
                lE0 = lD0: lE1 = lD1
                #If HasOperators Then
                    lD0 = (lC0 << 10 Or lC0 >> 22): lD1 = (lC1 << 10 Or lC1 >> 22)
                #Else
                    lD0 = RotL32(lC0, 10): lD1 = RotL32(lC1, 10)
                #End If
                lC0 = lB0: lC1 = lB1
                lB0 = lTemp0: lB1 = lTemp1
            Next
            #If HasOperators Then
                lTemp0 = .H1 + lC0 + lD1
                .H1 = .H2 + lD0 + lE1
                .H2 = .H3 + lE0 + lA1
                .H3 = .H4 + lA0 + lB1
                .H4 = .H0 + lB0 + lC1
                .H0 = lTemp0
            #Else
                lTemp0 = UAdd32(UAdd32(.H1, lC0), lD1)
                .H1 = UAdd32(UAdd32(.H2, lD0), lE1)
                .H2 = UAdd32(UAdd32(.H3, lE0), lA1)
                .H3 = UAdd32(UAdd32(.H4, lA0), lB1)
                .H4 = UAdd32(UAdd32(.H0, lB0), lC1)
                .H0 = lTemp0
            #End If
        Loop
    End With
End Sub

Public Sub CryptoRipeMd160Finalize(uCtx As CryptoRipeMd160Context, baOutput() As Byte)
    Static B(0 To 4)    As Long
    Dim P(0 To LNG_BLOCKSZ + 9) As Byte
    Dim lSize           As Long

    With uCtx
        lSize = LNG_BLOCKSZ - .NPartial
        If lSize < 9 Then
            lSize = lSize + LNG_BLOCKSZ
        End If
        P(0) = &H80
        .NInput = .NInput / 10000@ * 8
        Call CopyMemory(P(lSize - 8), .NInput, 8)
        CryptoRipeMd160Update uCtx, P, Size:=lSize
        Debug.Assert .NPartial = 0
        B(0) = .H0: B(1) = .H1: B(2) = .H2: B(3) = .H3: B(4) = .H4
        ReDim baOutput(0 To LNG_HASHSZ - 1) As Byte
        Call CopyMemory(baOutput(0), B(0), UBound(baOutput) + 1)
    End With
End Sub

Public Function CryptoRipeMd160ByteArray(baInput() As Byte, Optional ByVal Pos As Long, Optional ByVal Size As Long = -1) As Byte()
    Dim uCtx            As CryptoRipeMd160Context

    CryptoRipeMd160Init uCtx
    CryptoRipeMd160Update uCtx, baInput, Pos, Size
    CryptoRipeMd160Finalize uCtx, CryptoRipeMd160ByteArray
End Function

Private Function ToUtf8Array(sText As String) As Byte()
    Const CP_UTF8       As Long = 65001
    Dim baRetVal()      As Byte
    Dim lSize           As Long

    lSize = WideCharToMultiByte(CP_UTF8, 0, StrPtr(sText), Len(sText), ByVal 0, 0, 0, 0)
    If lSize > 0 Then
        ReDim baRetVal(0 To lSize - 1) As Byte
        Call WideCharToMultiByte(CP_UTF8, 0, StrPtr(sText), Len(sText), baRetVal(0), lSize, 0, 0)
    Else
        baRetVal = vbNullString
    End If
    ToUtf8Array = baRetVal
End Function

Private Function ToHex(baData() As Byte) As String
    Dim lIdx            As Long
    Dim sByte           As String

    ToHex = String$(UBound(baData) * 2 + 2, 48)
    For lIdx = 0 To UBound(baData)
        sByte = LCase$(Hex$(baData(lIdx)))
        If Len(sByte) = 1 Then
            Mid$(ToHex, lIdx * 2 + 2, 1) = sByte
        Else
            Mid$(ToHex, lIdx * 2 + 1, 2) = sByte
        End If
    Next
End Function

Public Function CryptoRipeMd160Text(sText As String) As String
    CryptoRipeMd160Text = ToHex(CryptoRipeMd160ByteArray(ToUtf8Array(sText)))
End Function
