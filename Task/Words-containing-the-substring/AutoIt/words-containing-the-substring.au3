; Includes not needed if you don't want to use the constants
#include <FileConstants.au3>
#include <StringConstants.au3>
#include <MsgBoxConstants.au3>

;Initialise some variables and constants
Local Const $sFileName = "unixdict.txt"
Local Const $sStrToFind = "the"
Local $iFoundResults = 0

; Open the file for reading and store the handle to a variable.
Local $hFileOpen = FileOpen($sFileName, $FO_READ)
If $hFileOpen = -1 Then
   MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
   Return False
EndIf

; Read the contents of the file using the handle returned by FileOpen.
Local $sFileRead = FileRead($hFileOpen)

; Close the handle returned by FileOpen.
FileClose($hFileOpen)

; Get each "word" that's on a new line
Local $aArray = StringSplit($sFileRead, @CRLF)

; Loop through the array returned by StringSplit to check the length and if it containes the "the" substring.
For $i = 1 To $aArray[0]
   If StringLen($aArray[$i]) > 11 Then
      If StringInStr($aArray[$i], $sStrToFind) <> 0 Then
         ; Increment the found results counter
         $iFoundResults += 1
         ; Log the output
         ConsoleWrite($aArray[$i])
         ConsoleWrite(@CRLF)
      EndIf
   EndIf
Next

ConsoleWrite("Found " & $iFoundResults & " words containing '" & $sStrToFind & "'")
