' Straddling checkerboard - VBScript - 19/04/2019

Function encrypt(ByVal originalText, ByVal alphabet, blank1, blank2)
  Const notEscape = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ."
  Dim i, j, curChar, escChar, outText
  Dim cipher  'Hash table
  Set cipher = CreateObject("Scripting.Dictionary")
  'build cipher reference
  alphabet = UCase(alphabet) : j = 0
  For i = 1 To 28
    curChar = Mid(alphabet, i, 1)
    Select Case True
      Case i>= 1 And i<= 8
        If j = blank1 Or j = blank2 Then j = j + 1  'adjust for blank
		cipher.Add curChar, CStr(j)
        j = j + 1
      Case i>= 9 And i<=18
		cipher.Add curChar, CStr(blank1) & CStr(i -  9)
      Case i>=19 And i<=28
		cipher.Add curChar, CStr(blank2) & CStr(i - 19)
    End Select 'i
    If InStr(notEscape, curChar) = 0 Then
      escChar = curChar
      'Wscript.Echo "escChar=" & escChar & "  cipher(escChar)=" & cipher(escChar)
    End If
  Next 'i
  For i = 0 To 9: cipher.Add CStr(i), cipher(escChar) & CStr(i): Next
  'encrypt each character
  originalText = UCase(originalText)
  For i = 1 To Len(originalText)
    outText = outText & cipher(Mid(originalText, i, 1))
  Next
  encrypt=outText
End Function 'encrypt

Function decrypt(ByVal cipherText, ByVal alphabet, blank1, blank2)
  Const notEscape = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ."
  Dim i, j, curChar, escCipher, outText
  Dim cipher  'Hash table
  Set cipher = CreateObject("Scripting.Dictionary")
  'build decipher reference
  alphabet = UCase(alphabet) : j = 0
  For i = 1 To 28
    curChar = Mid(alphabet, i, 1)
    Select Case True
      Case i>= 1 And i<= 8
        If j = blank1 Or j = blank2 Then j = j + 1  'adjust for blank
		cipher.Add CStr(j),curChar
        j = j + 1
      Case i>= 9 And i<=18
        cipher.Add CStr(blank1) & CStr(i -  9), curChar
      Case i>=19 And i<=28
        cipher.Add CStr(blank2) & CStr(i - 19), curChar
    End Select 'i
    If InStr(notEscape, curChar) = 0 Then
      'the last element of cipher
      arrayKeys=cipher.keys
      escCipher = arrayKeys(cipher.count-1)
      'Wscript.Echo "escCipher=" & escCipher & "  cipher(escCipher)=" & cipher(escCipher)
    End If
  Next 'i
  For i = 0 To 9: cipher.Add escCipher & CStr(i), CStr(i): Next
  'decrypt each character
  i = 1
  Do While i <= Len(cipherText)
    curChar = Mid(cipherText, i, 1)
    If curChar = CStr(blank1) Or curChar = CStr(blank2) Then
      curChar = Mid(cipherText, i, 2)
      If curChar = escCipher Then curChar = Mid(cipherText, i, 3)
    End If
    outText = outText & cipher(curChar)
    i = i + Len(curChar)
  Loop 'i
  decrypt=outText
End Function 'decrypt

  message = "One night-it was on the twentieth of March, 1888-I was returning"
  cipher = "HOLMESRTABCDFGIJKNPQUVWXYZ./"
  '3 7         <=8
  'HOL MES RT
  'ABCDFGIJKN
  'PQUVWXYZ./
  Buffer=Buffer & "Original: " & message & vbCrlf
  encoded = encrypt(message, cipher, 3, 7)
  Buffer=Buffer &  "encoded: " & encoded & vbCrlf
  decoded = decrypt(encoded, cipher, 3, 7)
  Buffer=Buffer &  "decoded: " & decoded & vbCrlf
  Wscript.Echo Buffer
