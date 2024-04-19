#include "curl.bi"
#include "vbcompat.bi"
#define NULL  0

Dim Shared As CURL Ptr curl = NULL

Function WriteMemoryCallback(Byval contents As Any Ptr, Byval size As Uinteger, Byval nmemb As Uinteger, Byval userp As String Ptr) As Uinteger
    Dim As Uinteger realsize = size * nmemb
    *userp &= *Cptr(ZString Ptr, contents)
    Return realsize
End Function

Function download(url As String) As String
    If curl = NULL Then
        curl_global_init(CURL_GLOBAL_DEFAULT)
        curl = curl_easy_init()
    End If
    Dim As String readBuffer = ""
    curl_easy_setopt(curl, CURLOPT_URL, url)
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, @WriteMemoryCallback)
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, @readBuffer)
    Dim As CURLcode res = curl_easy_perform(curl)
    If res <> 0 Then
        Print "libcurl error "; res; " ("; *curl_easy_strerror(res); ")"
        Return ""
    End If
    Return readBuffer
End Function

Function grep(needle As String, haystack As String) As String
    Dim As Integer i, j
    Dim As String res = ""
    j = 1
    For i = 1 To Len(haystack)
        If Mid(haystack, i, 1) = Chr(10) Then
            Dim As String linea = Mid(haystack, j, i - j)
            If Instr(linea, needle) Then
                res &= linea & Chr(10)
            End If
            j = i + 1
        End If
    Next i
    If Len(res) = 0 Then res = "no occurrences"
    Return res
End Function

Dim As String needle = "github"
Dim As Integer days = 10
Dim As Integer i
For i = -days To 0
    Dim As String dateStr = Format(Dateadd("d", i, Cdbl(Date)), "yyyy-mm-dd")
    Dim As String url = "http://tclers.tk/conferences/tcl/" & dateStr & ".tcl"
    Dim As String contents = download(url)
    If Len(contents) = 0 Then Exit For
    Print url
    Print grep(needle, contents)
Next i

Sleep
