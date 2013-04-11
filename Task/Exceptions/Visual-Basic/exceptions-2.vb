Sub bar1()
'by convention, a simple handler
    On Error Goto Catch
    fooX
    Exit Sub
Catch:
    'handle all exceptions
    Exit Sub

Sub bar2()
'a more complex handler, illustrating some of the flexibility of VBA exception handling
    on error goto catch
100     fooX
200     fooY
    'finally block may be placed anywhere: this is complexity for it's own sake:
    goto finally

catch:
    if erl= 100 then
        ' handle exception at first line: in this case, by ignoring it:
        resume next
    else
        select case err.nummber
        case vbObjectError + 1050
            ' handle exceptions of type 1050
        case vbObjectError + 1051
            ' handle exceptions of type 1051
        case else
            ' handle any type of exception not handled by above catches or line numbers
    resume finally

finally:
    'code here occurs whether or not there was an exception
    'block may be placed anywhere
    'by convention, often just a drop through to an Exit Sub, rather tnan a code block
    Goto end_try:

end_try:
    'by convention, often just a drop through from the catch block
exit sub
